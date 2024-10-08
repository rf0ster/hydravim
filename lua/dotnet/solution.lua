local actions_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local cli = require "dotnet.cli"

local M = {}
local sln_file
local sln_name
local projects = {}
local projects_loaded = false

local function add_project(project_name)
    local p_name = project_name .. '/' .. project_name .. ".csproj"
    cli.sln_add(sln_file, p_name)
    M.load(sln_file)
    vim.notify(p_name .. " added to " .. sln_name)
end

local commands = {
    {
        name = "Build",
        on_execute = function()
            cli.build(sln_file)
        end
    },
    {
        name = "Clean",
        on_execute = function()
            cli.clean(sln_file)
        end
    },
    {
        name = "Restore",
        on_execute = function()
            cli.restore(sln_file)
        end
    },
    {
        name = "Test",
        on_execute = function()
            cli.mstest(sln_file)
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
            cli.new_console(project_name)
            add_project(project_name)
        end
    },
    {
        name = "New classlib",
        on_execute = function()
            local project_name = vim.fn.input("Project name: ")
            cli.new_classlib(project_name)
            add_project(project_name)
        end
    },
    {
        name = "New web",
        on_execute = function()
            local project_name = vim.fn.input("Project name: ")
            cli.new_web(project_name)
            add_project(project_name)
        end
    },
    {
        name = "New mvc",
        on_execute = function()
            local project_name = vim.fn.input("Project name: ")
            cli.new_mvc(project_name)
            add_project(project_name)
        end
    },
    {
        name = "New mstest",
        on_execute = function()
            local project_name = vim.fn.input("Project name: ")
            cli.new_mstest(project_name)
            add_project(project_name)
        end
    }
}


-- Helper function to locate the solution file in the current directory using plenary.scandir
local function locate_file(match, depth)
    local found_solution = nil

    require "plenary.scandir" .scan_dir('.', {
        hidden = false,
        add_dirs = false,
        depth = depth or nil,
        on_insert = function(entry)
            if entry:match(match) then
                found_solution = entry
                return true
            end
        end
    })

    return found_solution
end

-- Load the solution file and cache the projects
function M.load(sln_file_path)
    if sln_file_path then
        sln_file = locate_file(sln_file_path)
    else
        sln_file = locate_file('%.sln$', 1)
    end

    if not sln_file then
        return
    end

    projects_loaded = false
    sln_name = sln_file:match("([^/\\]+%.sln)$")
    projects = {}

    local result = require "dotnet.cli" .sln_list(sln_file)
    if result ~= nil then
        for _, project in ipairs(result) do
            local project_name = project:match("([^/\\]+%.csproj)$")
            if project_name then
                table.insert(projects, {
                    file = project,
                    name = project_name
                })
            end
        end
    end
    projects_loaded = true
end

-- Get the solution information
function M.get()
    if not sln_file then
        M.load()
    end

    if not sln_file then
        return nil
    end

    return {
        name = sln_name,
        file = sln_file,
        projects = projects,
        projects_loaded = projects_loaded
    }
end

function M.open()
    local sln = M.get() or M.load()
    if not sln then
        return
    end

    local results = {}
    for _, command in ipairs(commands) do
        table.insert(results, command.name)
    end

    require "dotnet.view".picker({
        prompt_title = sln.name,
        results_title = "Options",
        finder = require "telescope.finders".new_table {
            results = results
        },
        attach_mappings = function(_, map)
            map("n", "<CR>", function(prompt_bufnr)
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
