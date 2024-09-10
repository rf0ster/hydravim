local M = {}

-- Helper function to run a shell command and capture the output
local function shell_command(cmd)
    print(cmd)

    local handle = io.popen(cmd)
    if handle == nil then
        return nil
    end

    local result = handle:read("*a")
    handle:close()
    return result
end

local function add_flag(flag, value)
    if value == nil then
        return ""
    end
    return " " .. flag .. " " .. value
end

local function add_target(target)
    if target == nil then
        return ""
    end
    return " " .. target
end

function M.sln_list(sln_file)
    return shell_command("dotnet sln " .. sln_file .. " list")
end

function M.sln_add(sln_file, project_file)
    return shell_command("dotnet sln " .. sln_file .. " add " .. project_file)
end

function M.sln_remove(sln_file, project_file)
    return shell_command("dotnet sln " .. sln_file .. " remove " .. project_file)
end

function M.restore(target)
    return require "dotnet.view".output("dotnet restore" .. add_target(target))
end

function M.build(target)
    return require "dotnet.view".output("dotnet build" .. add_target(target))
end

function M.clean(target)
    return require "dotnet.view".output("dotnet clean" .. add_target(target))
end

function M.mstest(target)
    return require "dotnet.view".output("dotnet test" .. add_target(target))
end

function M.new_classlib(name, output)
    local cmd = "dotnet new classlib -n " .. name
    return shell_command(cmd .. add_flag("-o", output))
end

function M.new_console(name, output)
    local cmd = "dotnet new console -n " .. name
    return shell_command(cmd .. add_flag("-o", output))
end

function M.new_mstest(name, output)
    local cmd = "dotnet new mstest -n " .. name
    return shell_command(cmd .. add_flag("-o", output))
end

function M.new_web(name, output)
    local cmd = "dotnet new web -n " .. name
    return shell_command(cmd .. add_flag("-o", output))
end

function M.new_mvc(name, output)
    local cmd = "dotnet new mvc -n " .. name
    return shell_command(cmd .. add_flag("-o", output))
end

return M
