local M = {}

function M.append(buf, data)
	vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
end

function M.clear(buf)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
end

function M.read_current_line(buf)
    local current_line = vim.api.nvim_buf_get_lines(
	    buf, vim.api.nvim_win_get_cursor(0)[1] - 1, vim.api.nvim_win_get_cursor(0)[1], false)[1]

    return vim.fn.expand(current_line)
end

function M.set_keymap_safe(buf, mode, key, fn, opts)
    pcall(vim.api.nvim_buf_del_keymap, buf, mode, key)
    vim.api.nvim_buf_set_keymap(buf, mode, key, fn, opts)
end

function M.run_command(buf, command)
    local function on_output(_, data, _)
        if data then
            M.append(buf, data)
        end
    end

    vim.fn.jobstart(command, {
        on_stdout = on_output,
        on_stderr = on_output,
        stdout_buffered = false,
        stderr_buffered = false,
    })
end

function M.pad(bufnr, left_padding, right_padding)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local padded_lines = {}

    for _, line in ipairs(lines) do
        if #line > 0 then
            local padded_line = string.rep(" ", left_padding) .. line .. string.rep(" ", right_padding)
            table.insert(padded_lines, padded_line)
        else
            table.insert(padded_lines, line)
        end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, padded_lines)
end

function M.disable_editing(buf)
    vim.bo[buf].modifiable = false
    vim.bo[buf].readonly = true  -- Optionally set the readonly flag as well
end

return M
