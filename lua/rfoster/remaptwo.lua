
-- Telescope
vim.keymap.set('n', '<leader>ff', ":lua require('telescope.builtin').find_files()<CR>", {})
vim.keymap.set('n', '<leader>fg', ":lua require('telescope.builtin').live_grep()<CR>", {})
vim.keymap.set('n', '<leader>fb', ":lua require('telescope.builtin').buffers()<CR>", {})
vim.keymap.set('n', '<leader>fh', ":lua require('telescope.builtin').help_tags()<CR>", {})

-- Neotree
vim.keymap.set('n', '<leader>eo', ':Neotree <CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>et', ':Neotree toggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>eq', ':Neotree close<CR>:wincmd p<CR>', { noremap = true, silent = true })

-- Previous buffer
vim.keymap.set('n', '<leader>p', ':wincmd p<CR>', { noremap = true, silent = true })

-- Mason
vim.keymap.set('n', '<leader>m', ':Mason<CR>', { noremap = true, silent = true })

-- Lazy
vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { noremap = true, silent = true })

-- Terminal
vim.keymap.set('n', '<C-t>', ':ToggleTerm<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-t>', ':ToggleTerm<CR>', { noremap = true, silent = true })

-- dotnet
vim.keymap.set('n', '<leader>db', ':lua require"dotnet.cli".build()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dc', ':lua require"dotnet.cli".clean()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dr', ':lua require"dotnet.cli".restore()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dh', ':lua require"dotnet.history".open()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dp', ':lua require"dotnet.projects".open()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ds', ':lua require"dotnet.solution".open()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dl', ':lua require"dotnet.history".run_last_cmd()<CR>', { noremap = true, silent = true })

-- Recall
vim.keymap.set('n', '<leader>rr', ':Recall<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<tab>', ':RecallForward<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<s-tab>', ':RecallBack<CR>', { noremap = true, silent = true })

-- lspsaga
vim.keymap.set('n', '<leader>t', ':Lspsaga finder<CR>', { noremap = true, silent = true })

