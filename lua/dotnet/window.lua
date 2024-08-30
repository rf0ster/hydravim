local M = {}

function M.create_window()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.9)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true) -- create a new empty buffer
	-- Disable insert mode in the buffer
  vim.api.nvim_buf_set_keymap(buf, 'n', 'i', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'a', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'o', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'O', '<nop>', { noremap = true, silent = true })

  -- Optionally disable other editing commands like paste
  vim.api.nvim_buf_set_keymap(buf, 'n', 'p', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'p', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'd', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'dd', '<nop>', { noremap = true, silent = true })

	local win = vim.api.nvim_open_win(buf, true, {
			relative = 'editor',
			width = width,
			height = height,
			row = row,
			col = col,
			style = 'minimal',
			border = 'rounded'
	})

	M.win = win
	M.buf = buf
	M.tabs = {}
end

function M.create_tab(name, key, on_tab)	
	local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'i', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'I', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'v', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'V', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'a', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'o', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'O', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'p', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'p', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'd', '<nop>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'dd', '<nop>', { noremap = true, silent = true })

	table.insert(M.tabs, {
		name = name,
		buf = buf,
		key = key,
		on_tab = on_tab,
	})

	local tab_num = #M.tabs
	for k,v in ipairs(M.tabs) do
		vim.api.nvim_buf_set_keymap(buf, "n", v.key, '', {
			noremap = true,
			silent = true,
			callback = function()
				M.tab_to(k)
			end
		})
		vim.api.nvim_buf_set_keymap(v.buf, "n", key, '', {
			noremap = true,
			silent = true,
			callback = function()
				M.tab_to(tab_num)
			end
		})
	end
end


function M.tab_to(tab_num)
	if tab_num < 1 or tab_num > #M.tabs then return end

	local tab_line = ""
	for v, k in ipairs(M.tabs) do
		if v == tab_num then
			tab_line = tab_line .. " [" .. k.name .. "] "
		else
			tab_line = tab_line .. "  " .. k.name .. "  "
		end
	end

	local buffer = require "dotnet.buffer"
	local tab = M.tabs[tab_num]

	buffer.clear(tab.buf)
	buffer.append(tab.buf, {tab_line})
	buffer.append(tab.buf, { "", "" })

	vim.api.nvim_win_set_buf(0, tab.buf)
	tab.on_tab(tab.buf)
end

function M.close()
	local wins = vim.api.nvim_list_wins()
	for _, win in ipairs(wins) do
		if win == M.win then
			vim.api.nvim_win_close(M.win, true)
			return true
		end
	end

	return false
end

return M
