local M = {}

function M.open()
    local telescope_actions_state = require "telescope.actions.state"
    local telescope_actions = require "telescope.actions"
    local dotnet_confirmation = require "dotnet.confirmation"
    local dotnet_solution = require "dotnet.solution"
    local dotnet_picker = require "dotnet.picker"
    local dotnet_cli = require "dotnet.cli"

    local sln_info = dotnet_solution.get_solution()
    if not sln_info then
        return
    end

    local sln_projects = dotnet_solution.get_projects()
    if not sln_projects then
        return
    end

    local projects = {}
    for _, project in ipairs(sln_projects) do
        table.insert(projects, project.name)
    end

    local function project_file(proj_name)
        for _, project in ipairs(sln_projects) do
            if project.name == proj_name then
                return project.file
            end
        end

        return nil
    end


    dotnet_picker.picker({
        prompt_title = sln_info.name,
        results_title = "Projects",
        items = projects,
        maps = {
            {
                mode = "n",
                key = "<CR>",
                fn = function (prompt_buffrn)
                    local selection = telescope_actions_state.get_selected_entry()
                    telescope_actions.close(prompt_buffrn)
                    vim.api.nvim_command("e " .. project_file(selection.value))
                end
            },
            {
                mode = "n",
                key = "b",
                fn = function()
                    local selection = telescope_actions_state.get_selected_entry()
                    dotnet_cli.build(project_file(selection.value))
                end
            },
            {
                mode = "n",
                key = "c",
                fn = function()
                    local selection = telescope_actions_state.get_selected_entry()
                    dotnet_cli.clean(project_file(selection.value))
                end
            },
            {
                mode = "n",
                key = "r",
                fn = function()
                    local selection = telescope_actions_state.get_selected_entry()
                    dotnet_cli.restore(project_file(selection.value))
                end
            },
            {
                mode = "n",
                key = "d",
                fn = function()
                    local selection = telescope_actions_state.get_selected_entry()
                    local prompt ="Delete " .. selection.value ..  " from " .. sln_info.name .. "?"
                    dotnet_confirmation.open({
                        prompt_title = "Delete Project",
                        prompt = {prompt},
                        on_close = function(answer)
                            if answer == "yes" then
                                dotnet_cli.sln_remove(sln_info.name, project_file(selection.value))
                                dotnet_solution.load_projects()
                            end
                        end
                    })
                end
            }
        },
    })
end

return M
