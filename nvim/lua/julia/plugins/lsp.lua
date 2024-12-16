local language_servers = { 'lua_ls', 'nil_ls', 'clangd', 'rust_analyzer' }

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
		'saghen/blink.cmp',
		lazy = false,
		dependencies = 'rafamadriz/friendly-snippets',
		version = 'v0.7.6',

		opts = {
			keymap = { preset = 'default' },
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
			},
			-- appearance = {
			-- 	use_nvim_cmp_as_default = true,
			-- 	nerd_font_variant = 'mono',
			-- },
			-- sources = {
			-- 	default = { 'lsp', 'path', 'snippets', 'buffer' },
			-- },
		},
	},

	--- Nicer lua lsp support
	{
		'folke/lazydev.nvim',
		event = 'BufEnter',
		ft = 'lua',
		opts = {
			library = {
				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
			},
		},
	},
}
