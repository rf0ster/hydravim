-- Tracks a history of commands that have been run for a single session.
local M = {
    cmds = {}
}

-- Adds a command to the history.
function M.add_cmd(cmd)
    table.insert(M.cmds, 1, cmd)
end

-- Opens a picker with the command history.
function M.open()
    local sln = require "dotnet.solution_manager".get_solution()
    if not sln then
        return
    end

    require "dotnet.view".picker({
        prompt_title = sln.name,
        results_title = "History",
        items = M.cmds,
        maps = {
            {
                mode = "n",
                key = "<CR>",
                fn = function(prompt_bufnr)
                    local selection = require "telescope.actions.state".get_selected_entry()
                    require "telescope.actions".close(prompt_bufnr)
                    require "dotnet.output".run_cmd(selection.value)
                end
            }
        }
    })
end

-- Runs the last command in the history.
function M.run_last_cmd()
    if M.cmds[1] then
        require "dotnet.output".run_cmd(M.cmds[1])
    end
end

return M
