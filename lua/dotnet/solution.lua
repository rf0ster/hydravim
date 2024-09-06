local dotnet = require('dotnet')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')

local M = {}

function  M.options()
    pickers.new({}, {
        initial_mode = "normal",
        prompt_title = "Solution",
        sorter = sorters.get_generic_fuzzy_sorter(),
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
            prompt_position = "top",
            width = 0.5,
            height = 0.5,
        },
        finder = finders.new_table {
            results = {
                "Build",
                "Clean",
                "Restore",
                "Add project",
                "New project",
            }
        },
        attach_mappings = function(_, map)
            map("n", "<CR>", function(prompt_bufnr)
                local selection = actions_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection.value == "Build" then
                    dotnet.build()
                elseif selection.value == "Clean" then
                    dotnet.build()
                elseif selection.value == "Restore" then
                    dotnet.build()
                elseif selection.value == "Add project" then
                    M.add_project()
                elseif selection.value == "New project" then
                    M.new_project()
                end
            end)
            return true
        end,
    }):find()
end

-- Build the solution
function M.build()
    require('dotnet').build()
end

-- Add a new project to the solution in the root directory
function M.new_project()
    local project_name = vim.fn.input("Enter project name: ")
    if project_name == nil or project_name == "" then
        return
    end

    -- Run a dotnet cli command to add the project to the solution
    vim.fn.jobstart("dotnet new console -n " .. project_name, {
        on_exit = function(_, exit_code, _)
            if exit_code ~= 0 or vim.fn.isdirectory(project_name) == 0 then
                error("Project not created")
                return
            end
            vim.fn.jobstart("dotnet sln add " .. project_name .. "/" .. project_name .. ".csproj", {
                on_exit = function(_, ec, _)
                    if ec ~= 0 then
                        error("Project not added to solution")
                        return
                    end
                    print("Project added to solution")
                end
            })
        end
    })
end

function M.add_project()
    local project_location = vim.fn.input("Project Location: ")
    if project_location == nil or project_location == "" then
        return
    end
    vim.fn.jobstart("dotnet sln add " .. project_location, {
        on_exit = function(_, exit_code, _)
            if exit_code ~= 0 then
                error("Project not added to solution")
                return
            end
            print("Project added to solution")
        end
    })
end

-- Add a new project to the solution in the root directory
function M.remove_project()
    local project_name = vim.fn.input("Enter project name: ")
    if project_name == nil or project_name == "" then
        return
    end

    -- Run a dotnet cli command to add the project to the solution
    vim.fn.jobstart("dotnet sln remove " .. project_name, {
        on_exit = function(_, exit_code, _)
            if exit_code ~= 0 then
                error("Project not removed from solution")
                return
            end
            print("Project removed from solution")
        end
    })
end

return M
