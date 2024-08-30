return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
		config = function()
			require("cyberdream").setup({
					transparent = true,
					italic_comments = true,
					hide_fillchars = false,
					borderless_telescope = false,
					terminal_colors = false,
					cache = false,
					theme = {
							variant = "auto",
					},

					-- Disable or enable colorscheme extensions
					extensions = {
							telescope = true,
							notify = true,
							mini = true,
							-- cmp = true,
							treesitter = true,
							noice = true
					},
			})
	  end
}
