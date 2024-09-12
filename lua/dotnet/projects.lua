local M = {}

function M.open()
    local solution = require "dotnet.solution"
    local sln = solution.get() or solution.load()
    if not sln then
        return
    end

    if not sln.projects_loaded then
        return
    end

    local projects = {}
    for _, project in ipairs(sln.projects) do
        table.insert(projects, project.name)
    end

    local function project_file(proj_name)
        for _, project in ipairs(sln.projects) do
            if project.name == proj_name then
                return project.file
            end
        end

        return nil
    end

    local actions_state = require "telescope.actions.state"
    local actions = require "telescope.actions"
    local cli = require "dotnet.cli"

    require "dotnet.view".picker({
        prompt_title = sln.name,
        results_title = "Projects",
        items = projects,
        maps = {
            {
                mode = "n",
                key = "<CR>",
                fn = function (prompt_buffrn)
                    local selection = actions_state.get_selected_entry()
                    actions.close(prompt_buffrn)
                    vim.api.nvim_command("e " .. project_file(selection.value))
                end
            },
            {
                mode = "n",
                key = "b",
                fn = function()
                    local selection = actions_state.get_selected_entry()
                    cli.build(project_file(selection.value))
                end
            },
            {
                mode = "n",
                key = "c",
                fn = function()
                    local selection = actions_state.get_selected_entry()
                    cli.clean(project_file(selection.value))
                end
            },
            {
                mode = "n",
                key = "r",
                fn = function()
                    local selection = actions_state.get_selected_entry()
                    cli.restore(project_file(selection.value))
                end
            },
            {
                mode = "n",
                key = "d",
                fn = function()
                    local selection = actions_state.get_selected_entry()
                    local prompt ="Delete " .. selection.value ..  " from " .. sln.name .. "?"
                    require "dotnet.confirmation".open({
                        prompt_title = "Delete Project",
                        prompt = {prompt},
                        on_close = function(answer)
                            if answer == "yes" then
                                cli.sln_remove(sln.name, project_file(selection.value))
                                solution.load()
                            end
                        end
                    })
                end
            }
        },
    })
end

return M
