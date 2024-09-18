return {
	'akinsho/toggleterm.nvim',
    version = "*",
	lazy = true,
	config = function()
		require('toggleterm').setup({
			persist_mode = false,
		})
	end
}
