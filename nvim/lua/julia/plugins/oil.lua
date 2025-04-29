return {
	'stevearc/oil.nvim',

	enabled = require('utils').enableForCat 'oil',

	opts = {
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			natural_order = true,
			show_hidden = true,
		},
	},

	keys = {
		{ '<leader>ef', '<cmd>Oil<CR>', desc = 'Open parent directory' },
	},
}
