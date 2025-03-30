local utils = require 'utils'

return {
	{
		'tpope/vim-fugitive',
		enable = utils.enableForCat 'git',
	},

	{
		'lewis6991/gitsigns.nvim',
		enable = utils.enableForCat 'git',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},
}
