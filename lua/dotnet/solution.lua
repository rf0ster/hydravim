local M = {}

function M.open()
    local dotnet_solution_manager = require "dotnet.solution_manager"
    local dotnet_cli = require "dotnet.cli"

    local sln_info = dotnet_solution_manager.get_solution()
    if not sln_info then
        return
    end

    local function add_project(project_name)
        local p_name = project_name .. '/' .. project_name .. ".csproj"
        dotnet_cli.sln_add(sln_info.file, p_name)
        dotnet_solution_manager.load_projects()
        vim.notify(p_name .. " added to " .. sln_info.name)
    end

    local commands = {
        {
            name = "Build",
            on_execute = function()
                dotnet_cli.build(sln_info.file)
            end
        },
        {
            name = "Clean",
            on_execute = function()
                dotnet_cli.clean(sln_info.file)
            end
        },
        {
            name = "Restore",
            on_execute = function()
                dotnet_cli.restore(sln_info.file)
            end
        },
        {
            name = "Test",
            on_execute = function()
                dotnet_cli.mstest(sln_info.file)
            end
        },
        {
            name = "Add project",
            on_execute = function()
                print("Add project")
            end
        },
        {
            name = "New console",
            on_execute = function()
                local project_name = vim.fn.input("Project name: ")
                dotnet_cli.new_console(project_name)
                add_project(project_name)
            end
        },
        {
            name = "New classlib",
            on_execute = function()
                local project_name = vim.fn.input("Project name: ")
                dotnet_cli.new_classlib(project_name)
                add_project(project_name)
            end
        },
        {
            name = "New web",
            on_execute = function()
                local project_name = vim.fn.input("Project name: ")
                dotnet_cli.new_web(project_name)
                add_project(project_name)
            end
        },
        {
            name = "New mvc",
            on_execute = function()
                local project_name = vim.fn.input("Project name: ")
                dotnet_cli.new_mvc(project_name)
                add_project(project_name)
            end
        },
        {
            name = "New mstest",
            on_execute = function()
                local project_name = vim.fn.input("Project name: ")
                dotnet_cli.new_mstest(project_name)
                add_project(project_name)
            end
        }
    }

    local results = {}
    for _, command in ipairs(commands) do
        table.insert(results, command.name)
    end

    require "dotnet.view".picker({
        prompt_title = sln_info.name,
        results_title = "Options",
        finder = require "telescope.finders".new_table {
            results = results
        },
        attach_mappings = function(_, map)
            map("n", "<CR>", function(prompt_bufnr)
                local actions_state = require "telescope.actions.state"
                local actions = require "telescope.actions"

                local selection = actions_state.get_selected_entry().value
                for _, command in ipairs(commands) do
                    if command.name == selection then
                        command.on_execute()
                        break
                    end
                end
                pcall(actions.close, prompt_bufnr)
            end)
            return true
        end
    })
end

return M
