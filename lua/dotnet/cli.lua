local dotnet_output = require "dotnet.output"
local M = {}

-- Helper function to run a shell command and capture the output
-- Using a wrapper function because I am have played around with different ways to run shell commands.
local function shell_command(cmd)
    return vim.fn.systemlist(cmd)
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

function M.new_classlib(name, output)
    return shell_command("dotnet new classlib -n " .. name .. add_flag("-o", output))
end

function M.new_console(name, output)
    return shell_command("dotnet new console -n " .. name .. add_flag("-o", output))
end

function M.new_mstest(name, output)
    return shell_command("dotnet new mstest -n " .. name .. add_flag("-o", output))
end

function M.new_web(name, output)
    return shell_command("dotnet new web -n " .. name.. add_flag("-o", output))
end

function M.new_mvc(name, output)
    return shell_command("dotnet new mvc -n " .. name .. add_flag("-o", output))
end

function M.test_list_all(target)
    return shell_command("dotnet test --list-tests" .. add_target(target))
end

function M.restore(target)
    return dotnet_output.run_cmd("dotnet restore" .. add_target(target))
end

function M.build(target)
    return dotnet_output.run_cmd("dotnet build" .. add_target(target))
end

function M.clean(target)
    return dotnet_output.run_cmd("dotnet clean" .. add_target(target))
end

function M.mstest(target)
    return dotnet_output.run_cmd("dotnet test" .. add_target(target))
end

return M
