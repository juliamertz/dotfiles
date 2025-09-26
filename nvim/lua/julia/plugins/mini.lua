return {
	{
		'echasnovski/mini.surround',
		opts = {
			mappings = {
				add = 'ys',
				delete = 'ds',
				replace = 'cs',
				find = '',
				find_left = '',
				highlight = '',
				update_n_lines = '',
				suffix_last = '',
				suffix_next = '',
			},
		},
	},

	{
		'echasnovski/mini.comment',
		opts = {},
	},

	{
		'echasnovski/mini.icons',
		lazy = false,
		config = function()
			local icons = require 'mini.icons'
			icons.mock_nvim_web_devicons()
		end,
	},
}
