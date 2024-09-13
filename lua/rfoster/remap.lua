local togglefiles = function()
	local minifiles = require"mini.files"
	if not minifiles.close() then minifiles.open() end
end

local newwindow = function(window)
	return function()
		require "mini.files".close()
		window()
	end
end

local close_to_startup = function()
	if #vim.api.nvim_list_wins() > 1 then
		vim.cmd[[q! | Startup display]]
	else
		vim.cmd[[Startup display]]
	end
end

local toggle_terminal = function()
	require "toggleterm"
	vim.cmd[[ToggleTerm]]
end

-- Telescope
vim.keymap.set('n', '<leader>ff', newwindow(require('telescope.builtin').find_files), {})
vim.keymap.set('n', '<leader>fg', newwindow(require('telescope.builtin').live_grep), {})
vim.keymap.set('n', '<leader>fb', newwindow(require('telescope.builtin').buffers), {})
vim.keymap.set('n', '<leader>fh', newwindow(require('telescope.builtin').help_tags), {})

-- Mini.Files
vim.keymap.set('n', '<leader>e', togglefiles, { noremap = true, silent = true })

-- Mason
vim.keymap.set('n', '<leader>m', ':Mason<CR>', { noremap = true, silent = true })

-- Lazy
vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { noremap = true, silent = true })

-- Terminal
vim.keymap.set('n', '<C-t>', toggle_terminal, { noremap = true, silent = true })
vim.keymap.set('t', '<C-t>', toggle_terminal, { noremap = true, silent = true })

-- dotnet
vim.keymap.set('n', '<leader>db', ':lua require"dotnet.cli".build()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dc', ':lua require"dotnet.cli".clean()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dr', ':lua require"dotnet.cli".restore()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dh', ':lua require"dotnet.history".open()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dp', ':lua require"dotnet.projects".open()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ds', ':lua require"dotnet.solution".open()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dl', ':lua require"dotnet.history".run_last_cmd()<CR>', { noremap = true, silent = true })

-- recalling
vim.keymap.set('n', '<leader>rr', ':Recall<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<tab>', ':RecallForward<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<s-tab>', ':RecallBack<CR>', { noremap = true, silent = true })

-- lspsaga
vim.keymap.set('n', '<leader>t', ':Lspsaga finder<CR>', { noremap = true, silent = true })

-- remaps, not sure if this is good practice, but nice to have for laptop where ctrl key is not remapped :(
vim.keymap.set('n', '<leader>q', close_to_startup, { noremap = true, silent = true })

vim.api.nvim_create_user_command('Q', function()
    vim.cmd('bp | bd #')
end, {})

