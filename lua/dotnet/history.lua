local M = {
    cmds = {}
}

function M.add_cmd(cmd)
    table.insert(M.cmds, 1, cmd)
end

function M.last_cmd()
    return M.cmds[1]
end

function M.open()
    local actions_state = require "telescope.actions.state"
    local actions = require "telescope.actions"
    local view = require "dotnet.view"

    view.picker({
        prompt_title = "History",
        items = M.cmds,
        maps = {
            {
                mode = "n",
                key = "<CR>",
                fn = function(prompt_bufnr)
                    local selection = actions_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    view.output(selection.value)
                end
            }
        }
    })
end

function M.run_last_cmd()
    local cmd = M.last_cmd()
    if cmd then
        require "dotnet.view".output(cmd)
    end
end

return M
