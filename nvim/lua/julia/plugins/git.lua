local utils = require 'utils'

return {
	-- {
	-- 	'tpope/vim-fugitive',
	-- 	enabled = utils.enableForCat 'git',
	-- },

	{
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
			'nvim-telescope/telescope.nvim',
		},
	},

	{
		'lewis6991/gitsigns.nvim',
		enabled = utils.enableForCat 'git',
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
