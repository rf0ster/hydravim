local M = {}

function M.append(buf, data)
	local line_count = vim.api.nvim_buf_line_count(buf)
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
return M
