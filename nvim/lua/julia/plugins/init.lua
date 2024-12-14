return {
	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	{
		'stevearc/oil.nvim',
		dependencies = { 'echasnovski/mini.icons' },
		lazy = false,
		opts = {},
		keys = {
			{ '<leader>ef', ':Oil<CR>', mode = 'n', desc = 'Open oil.nvim file browser' },
		},
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		opts = {},
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
}
