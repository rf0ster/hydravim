return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
		config = function()
			require("cyberdream").setup({
                transparent = true,
                italic_comments = true,
                hide_fillchars = false,
                borderless_telescope = false,
                terminal_colors = true,
                cache = true,
                theme = {
                    variant = "dark",
                },

                -- Disable or enable colorscheme extensions
                extensions = {
                    lazy = true,
                    telescope = true,
                    notify = true,
                    mini = true,
                    cmp = true,
                    treesitter = true,
                    noice = true
                },
			})
	  end
}
