return {
	{
    "neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require"mason".setup({
				ui = {
					border = "rounded"
				}
			})
			require"mason-lspconfig".setup({
				ensure_installed = { "lua_ls", "csharp_ls" }
			})

			local capabilities = require "cmp_nvim_lsp".default_capabilities()
			require "lspconfig".csharp_ls.setup {}
			require "lspconfig".lua_ls.setup {
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							-- LuaJIT in the case of Neovim
							version = 'LuaJIT',
							path = vim.split(package.path, ';'),
						},
						diagnostics = {
							globals = {'vim'},
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						}
					}
				}
			}
		end
	},

	{
    "hrsh7th/nvim-cmp",
		event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
				{
          { name = 'buffer' },
        })
      })

      -- Setup buffer source for `/`
      cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' }
        }
      })

      -- Setup cmdline & path source for `:`
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  }
}
