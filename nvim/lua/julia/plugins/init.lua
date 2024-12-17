return {

	{
		'stevearc/oil.nvim',
		opts = {},
		dependencies = { { 'echasnovski/mini.icons', opts = {} } },
		config = function()
			require('oil').setup {}
			local opts = { noremap = true, silent = true }
			vim.keymap.set('n', '<leader>ef', ':Oil<CR>', opts)
		end,
	},

	{
		'nat-418/boole.nvim',
		event = 'VeryLazy',
		config = {
			mappings = {
				increment = '<C-s>',
				decrement = '<C-x>',
			},
		},
	},

	--- Color highlighter and picker
	{
		'uga-rosa/ccc.nvim',
		config = function()
			require('ccc').setup {
				highlighter = {
					auto_enable = true,
					lsp = true,
				},
			}

			local opts = { noremap = true, silent = true }
			vim.keymap.set('n', '<leader>cc', ':CccConvert<CR>', opts)
			vim.keymap.set('n', '<leader>cp', ':CccPick<CR>', opts)
		end,
	},

	{
		'mrcjkb/rustaceanvim',
		version = '^5',
		lazy = false,
	},

	{
		'MeanderingProgrammer/render-markdown.nvim',
		opts = {},
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
	},
}
