return {
	{
		'williamboman/mason.nvim',
		opts = { PATH = 'append' },
		dependencies = { 'williamboman/mason-lspconfig.nvim' },
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		event = 'BufRead',
		branch = 'v2.x',
		dependencies = {
			{ 'neovim/nvim-lspconfig' },
			{ 'onsails/lspkind.nvim' },
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'L3MON4D3/LuaSnip' },
		},
		config = function()
			local lsp = require 'lsp-zero'
			lsp.preset 'recommended'

			local cmp = require 'cmp'
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			lsp.setup_nvim_cmp {
				mapping = lsp.defaults.cmp_mappings {
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-y>'] = cmp.mapping.confirm { select = true },
					['<C-Space>'] = cmp.mapping.complete(),
					['<Tab>'] = nil,
					['<S-Tab>'] = nil,
				},
			}

			lsp.on_attach(function(_, bufnr)
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
				vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
				vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
				vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
				vim.keymap.set('n', '<leader>vws', require('telescope.builtin').lsp_workspace_symbols, opts)
			end)

			vim.diagnostic.config { virtual_text = true }
			lsp.setup()
		end,
	},
	{
		'nvimtools/none-ls.nvim',
		event = 'BufRead',
		opts = {},
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
	--- Nicer rust lsp support
	{
		'mrcjkb/rustaceanvim',
		version = '^5',
		lazy = false,
	},
}
