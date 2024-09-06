local M = {}

local sln_file
local sln_name
local projects = {}

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

    sln_name = sln_file:match("([^/\\]+%.sln)$")
    projects = {}

    local result = require "dotnet2.cli" .sln_list(sln_file)
    if result ~= nil then
        for project in result:gmatch("[^\r\n]+") do
            local project_name = project:match("([^/\\]+%.csproj)$")
            if project_name then
                table.insert(projects, {
                    file = project,
                    name = project_name
                })
            end
        end
    end
end

-- Reloads the solution file and cache the projects
function M.reload()
    M.load(sln_file)
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
        projects = projects
    }
end

return M
