local utils = require 'utils'
local enable = utils.enableForCat 'folke'

return {
	{
		'folke/trouble.nvim',
		cmd = 'Trouble',
		enable = enable,

		opts = {
			auto_close = true,
			modes = {
				symbols = {
					desc = 'document symbols',
					mode = 'lsp_document_symbols',
					focus = true,
					win = {
						position = 'right',
						size = 0.4,
					},
				},
			},
		},

		keys = {
			{ '<leader>pr', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
			{ '<leader>vrr', '<cmd>Trouble lsp_references toggle<cr>', desc = 'Symbols (Trouble)' },
			{ '<leader>cs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
			{ '<leader>td', '<cmd>Trouble todo toggle<cr>', desc = 'Symbols (Trouble)' },
		},
	},

	{
		'folke/todo-comments.nvim',
		event = 'VimEnter',
		dependencies = { 'nvim-lua/plenary.nvim' },
		enable = enable,

		opts = { signs = false },
	},

	{
		'folke/snacks.nvim',

		opts = {
			notifier = { enabled = true },
			image = { enabled = true },
			bigfile = { enabled = true },
			picker = { enabled = true },
		},
	},
}
