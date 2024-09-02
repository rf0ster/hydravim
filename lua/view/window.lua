local M = {}

function M.create(width, height, buf)
	local w = math.floor(vim.o.columns * width)
	local h = math.floor(vim.o.lines * height)
	local row = math.floor((vim.o.lines - h) / 2)
	local col = math.floor((vim.o.columns - w) / 2)

	if buf == nil then
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win = vim.api.nvim_open_win(buf, true, {
			relative = 'editor',
			width = w,
			height = h,
			row = row,
			col = col,
			style = 'minimal',
			border = 'rounded'
	})

	local close = function ()
		for _, i in ipairs(vim.api.nvim_list_wins()) do
			if win == i then
				vim.api.nvim_win_close(win, true)
				return true
			end
		end

		return false
	end

	local window = {
		win = win,
		buf = buf,
		close = close
	}
	return window
end

function M.win_float_opts(width, height)
	local w = math.floor(vim.o.columns * width)
	local h = math.floor(vim.o.lines * height)
	local row = math.floor((vim.o.lines - h) / 2)
	local col = math.floor((vim.o.columns - w) / 2)
	return {
        relative = 'editor',
        width = w,
        height = h,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded'
	}
end

function M.create_float_cmd(cmd, opts)
	local buf = vim.api.nvim_create_buf(false, true)
	require "view.buffer".run_command(buf, cmd)

	local win = vim.api.nvim_open_win(buf, true, opts)
	return {
		win = win,
		buf = buf
	}
end

return M
