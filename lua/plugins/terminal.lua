return {
	'akinsho/toggleterm.nvim', version = "*", 
	lazy = true,
	config = function()
		require('toggleterm').setup({
			direction = 'float',
			float_opts = {
				border = 'rounded',
				width = function() return math.floor(vim.o.columns * 0.9) end,
				row = function() return math.floor(vim.o.lines / 16) end,
				col = function() return math.floor((vim.o.columns - vim.o.columns * 0.9) / 2) end
			},
			-- highlights = {
			--	FloatBorder = {
			--		guifg = "#56B6C2",
			--	}
			-- },
			persist_mode = false,
		})
	end
}
