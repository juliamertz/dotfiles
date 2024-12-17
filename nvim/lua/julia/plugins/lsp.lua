local language_servers = { 'lua_ls', 'nil_ls', 'clangd' }

return {
	{
		'williamboman/mason-lspconfig.nvim',
		opts = { ensure_installed = language_servers },

		dependencies = {
			{
				'williamboman/mason.nvim',
				opts = { PATH = 'append' },
			},
		},
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = { 'saghen/blink.cmp' },

		opts = { servers = { rust_analyzer = {}, } },

		config = function(_, options)
			local lspconfig = require 'lspconfig'
			local blink = require 'blink.cmp'

			local lspconfig_defaults = lspconfig.util.default_config
			local cmp_capabilites = blink.get_lsp_capabilities()
			lspconfig_defaults.capabilities =
				vim.tbl_deep_extend('force', lspconfig_defaults.capabilities, cmp_capabilites)

			for _, server in ipairs(language_servers) do
				options.servers[server] = {}
			end

			for server, config in pairs(options.servers) do
				lspconfig[server].setup {
					capabilities = blink.get_lsp_capabilities(config.capabilities),
				}
			end

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(event)
					local opts = { buffer = event.buf, remap = false }
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
					vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
					vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<leader>vws', require('telescope.builtin').lsp_workspace_symbols, opts)
				end,
			})
		end,
	},
	{
		'nvimtools/none-ls.nvim',
		event = 'BufRead',
		opts = {},
	},

	{
		'L3MON4D3/LuaSnip',
		version = 'v2.*',
		build = 'make install_jsregexp',
		config = function()
			local luasnip = require 'luasnip'
			luasnip.setup {}
			require('julia.snippets.init').init()
		end,
	},

	{
		'saghen/blink.cmp',
		lazy = false,
		dependencies = {
			{ 'L3MON4D3/LuaSnip', version = 'v2.*' },
			{ 'rafamadriz/friendly-snippets' },
		},

		version = 'v0.7.6',

		opts = {
			keymap = { preset = 'default' },
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
			},

			snippets = {
				expand = function(snippet)
					require('luasnip').lsp_expand(snippet)
				end,
				active = function(filter)
					if filter and filter.direction then
						return require('luasnip').jumpable(filter.direction)
					end
					return require('luasnip').in_snippet()
				end,
				jump = function(direction)
					require('luasnip').jump(direction)
				end,
			},

			sources = {
				default = { 'lsp', 'path', 'luasnip', 'buffer' },
			},

			appearance = {
				nerd_font_variant = 'mono',
			},
		},
	},
}
