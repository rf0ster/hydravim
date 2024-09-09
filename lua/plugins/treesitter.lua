return {
  -- Tree-sitter for Lua
  {
    "nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "lua", "c_sharp", "go" },
				sync_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
			  }
      }
    end,
  },
}
