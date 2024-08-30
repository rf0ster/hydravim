return {
  'glepnir/lspsaga.nvim',    
	nvimdependencies = {
		'nvim-treesitter/nvim-treesitter', -- optional
		'nvim-tree/nvim-web-devicons',     -- optional
	},
	event = "LspAttach",
  config = function()
    require('lspsaga').setup({
			lightbulb = {
				enable = false,
			}
		})
  end,
}
