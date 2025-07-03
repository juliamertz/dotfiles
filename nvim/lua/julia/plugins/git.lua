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

		keys = {
			{ '<leader>sc', '<cmd>Neogit<cr>', desc = 'Open Git UI' },
			{ '<leader>gc', '<cmd>Neogit commit<cr>', desc = 'Open commit pane' },
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

		keys = {
			{ '<leader>gb', '<cmd>Gitsigns blame<cr>', desc = 'Open git blame' },
		},
	},
}
