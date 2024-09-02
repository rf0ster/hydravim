local M = {}

local scandir = require('plenary.scandir')
local window = require('view.window')
local buffer = require('view.buffer')

-- Cache for the solution and projects information
local solution_info = nil

-- Helper function to run a shell command and capture the output
local function run_command(cmd)
    local handle = io.popen(cmd)
		if handle == nil then
			return nil
		end

    local result = handle:read("*a")
    handle:close()
    return result
end

-- Helper function to locate the solution file in the current directory using plenary.scandir
local function locate_solution_file()
    local found_solution = nil

    scandir.scan_dir('.', {
        hidden = false,
        add_dirs = false,
        depth = 1,
        on_insert = function(entry)
            if entry:match('%.sln$') then
                found_solution = entry
                return true
            end
        end
    })

    return found_solution
end

-- Helper function to cache projects in the solution
local function cache_projects(solution_file)
    local cmd = "dotnet sln " .. solution_file .. " list"
    local result = run_command(cmd)
		if result == nil then
			return {}
		end

    local projects = {}
    for project in result:gmatch("[^\r\n]+") do
        local project_name = project:match("([^/\\]+%.csproj)$")
        if project_name then
            table.insert(projects, {
                filePath = project,
                name = project_name
            })
        end
    end
    return projects
end

-- Set or get the solution information
function M.get_solution(sln_file)
    if not sln_file then
        sln_file = locate_solution_file()
    end
    if not sln_file then
        return nil
    end

    solution_info = {
        filePath = sln_file,
        name = sln_file:match("([^/\\]+%.sln)$"), -- Extract the solution name from the path
        projects = cache_projects(sln_file)
    }
    return solution_info
end

-- Get all projects in the solution
function M.get_projects()
    if not solution_info then
        M.get_solution()
    end
    if solution_info == nil then
        return {}
    end
    return solution_info.projects
end

local win_id = nil
local last_cmd = nil
local function float_cmd(cmd)
    print(cmd)
    if win_id then
         pcall(vim.api.nvim_win_close, win_id, true)
    end
    win_id = window.create_float_cmd(cmd, window.win_float_opts(0.7, 0.7)).win
    last_cmd = cmd
end

local function dotnet_cmd(cmd, project)
    if not solution_info then
        M.get_solution()
    end
    if not solution_info then
        return
    end

    if not project then
        local bufnr = vim.api.nvim_get_current_buf()
        local line = buffer.read_current_line(bufnr)
        project = line:match("([^/\\]+%.csproj)$")
    end

    if project then
        for _, proj in ipairs(solution_info.projects) do
            if proj.name == project then
                 float_cmd(cmd .. " " .. proj.filePath)
            end
        end
    else
        float_cmd(cmd .. " " .. solution_info.filePath)
    end
end

function M.run_last_cmd()
    if last_cmd then
        float_cmd(last_cmd)
    end
end

function M.clean(project)
    dotnet_cmd("dotnet clean", project)
end

function M.restore(project)
    dotnet_cmd("dotnet restore", project)
end

function M.build(project)
    dotnet_cmd("dotnet build", project)
end

function M.project_viewer()
    if not solution_info then
        M.get_solution()
    end
    if not solution_info then
        return
    end

    local viewer = require('dotnet.viewer')
    local items = {}
    for _, project in ipairs(solution_info.projects) do
        table.insert(items, project.name)
    end

    local actions_state = require('telescope.actions.state')
    local maps = {
        {
            mode = 'n',
            key = 'b',
            fn = function()
                local selection = actions_state.get_selected_entry()
                M.build(selection[1])
            end
        },
        {
            mode = 'n',
            key = 'c',
            fn = function()
                local selection = actions_state.get_selected_entry()
                M.clean(selection[1])
            end
        },
        {
            mode = 'n',
            key = 'r',
            fn = function()
                local selection = actions_state.get_selected_entry()
                M.restore(selection[1])
            end
        }
    }

    viewer.viewer({
        prompt_title = "Project Viewer",
        items = items,
        maps = maps
    })
end
return M
