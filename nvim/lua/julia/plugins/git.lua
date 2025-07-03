local utils = require 'utils'

return {
	{
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
			'nvim-telescope/telescope.nvim',
		},
		init = function()
			vim.cmd [[
        cnoreabbrev G Neogit
        cnoreabbrev Git Neogit
      ]]
		end,
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
