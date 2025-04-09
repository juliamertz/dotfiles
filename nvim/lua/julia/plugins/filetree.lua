local utils = require 'utils'

return {
	{
		'nvim-tree/nvim-tree.lua',
		enabled = utils.enableForCat 'filetree',

		dependencies = utils.optionalCat('have_nerd_font', {
			'echasnovski/mini.icons',
		}),

		opts = {
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = false,
			},
			sort_by = 'extension',
			view = {
				side = 'right',
				width = 30,
			},
			notify = {
				threshold = vim.log.levels.ERROR,
			},
		},

		keys = {
			{ '<C-b>', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle filetree' },
		},
	},
}
