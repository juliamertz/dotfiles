local utils = require 'utils'

return {
	{
		'uga-rosa/ccc.nvim',
		opts = {
			highlighter = { auto_enable = true },
		},
	},

	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
		opts = {},
	},
}
