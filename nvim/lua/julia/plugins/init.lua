return {
	{
		'uga-rosa/ccc.nvim',
		event = 'BufEnter',

		opts = {
			highlighter = { auto_enable = true },
		},

		keys = {
			{ '<leader>cc', '<cmd>CccPick<CR>', desc = 'Open color picker' },
		},
	},

	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
		opts = {},
	},

	{
		'nat-418/boole.nvim',
		opts = {
			mappings = {
				increment = '<C-s>',
				decrement = '<C-x>',
			},
		},
	},
}
