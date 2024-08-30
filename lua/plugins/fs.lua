return {
	{
		"echasnovski/mini.nvim",
		lazy = true,
		version = false,
		config = function()
			require("mini.files").setup()
		end
	},
}
