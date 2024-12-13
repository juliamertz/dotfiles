return {
	{
		'echasnovski/mini.icons',
		version = '*',
		opts = {},
	},
	{
		'echasnovski/mini.pairs',
		version = '*',
		opts = {},
	},
	{
		'echasnovski/mini.align',
		version = '*',
		opts = {},
	},
	{
		'echasnovski/mini.comment',
		version = '*',
		opts = {},
	},

	{
		'echasnovski/mini.statusline',
		version = '*',
		opts = {
			content = {
				active = nil,
				inactive = nil,
			},
			use_icons = true,
			set_vim_settings = true,
		},
	},
	{
		'echasnovski/mini.surround',
		version = '*',
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
		'echasnovski/mini.files',
		enabled = false,
		dependencies = { 'folke/snacks.nvim' },
		version = '*',
		opts = {},
		keys = {
			{
				'<C-b>',
				function()
					local mf = require 'mini.files'
					local state = mf.get_explorer_state()
					if state == nil then
						mf.open()
					else
						mf.close()
					end
				end,
				mode = 'n',
				desc = 'Open oil.nvim file browser',
			},
		},
	},
}
