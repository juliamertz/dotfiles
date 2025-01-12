local language_servers = {
	'lua_ls',
	'clangd',
	'denols',
	'gopls',
	'nil_ls',
	'zls',
	'volar',
	'ts_ls',
}

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

		opts = { servers = {} },

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

			lspconfig.gleam.setup {}

			-- temporary fix for rust-analzyer throwing errors
			for _, method in ipairs { 'textDocument/diagnostic', 'workspace/diagnostic' } do
				local default_diagnostic_handler = vim.lsp.handlers[method]
				vim.lsp.handlers[method] = function(err, result, context, config)
					if err ~= nil and (err.code == -32802 or err.code == -32603) then
						return
					end
					return default_diagnostic_handler(err, result, context, config)
				end
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

		version = '*',

		opts = {
			keymap = {
				preset = 'none',
				['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<C-e>'] = { 'hide' },
				['<C-y>'] = { 'select_and_accept' },

				['<C-p>'] = { 'select_prev', 'fallback' },
				['<C-n>'] = { 'select_next', 'fallback' },

				['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
				['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
			},
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
