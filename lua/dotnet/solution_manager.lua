local M = {
    file = nil,
    name = nil,
    projects = nil,
}

local cli = require "dotnet.cli"

-- Locates a file on disk based on a pattern
-- @param match The pattern to match
-- @param depth The depth to search
-- @return The path to the file
local function locate_file(match, depth)
    local file = nil

    require "plenary.scandir".scan_dir('.', {
        hidden = false,
        add_dirs = false,
        depth = depth or nil,
        on_insert = function(entry)
            if entry:match(match) then
                file = entry
                return true
            end
        end
    })

    return file
end

-- Load the solution file and cache the projects
-- @param sln_file_path The path to the solution file
function M.load_solution(sln_file_path)
    if sln_file_path then
        M.file = locate_file(sln_file_path)
    else
        M.file = locate_file('%.sln$', 1)
    end

    if M.file then
        M.name = M.file:match("([^/\\]+%.sln)$")
    end
end

-- Loads the projects for the solution.
-- If there is no solution loaded in the module, it will load the solution first.
function M.load_projects()
    if not M.file then
        M.load_solution()
    end

    if not M.file then
        return
    end

    local result = cli.sln_list(M.file)
    if result == nil then
        return
    end

    local projects = {}
    for _, project_file in ipairs(result) do
        local project_name = project_file:match("([^/\\]+%.csproj)$")
        if project_name then
            table.insert(projects, {
                file = project_file,
                name = project_name,
                tests = M.load_tests(project_file)
            })
        end
    end
    M.projects = projects
end

-- Returns a table of the list of tests found in a given project files.
-- @param project_file The path to the project file
-- @return A table of the list of tests found in the project file
function M.load_tests(project_file)
    local output = cli.test_list_all(project_file)
    if not output then
        return {}
    end

    local tests = {}
    local test_capture_start = false
    for _, line in ipairs(output) do
        if line:find('The following Tests are available') then
            test_capture_start = true
        elseif test_capture_start and line ~= '' then
            table.insert(tests, line:match("^%s*(.-)%s*$"))
        end
    end

    return tests
end

return M
