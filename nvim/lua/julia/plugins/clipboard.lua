return {
	'gbprod/yanky.nvim',
	enabled = require('utils').enableForCat 'clipboard',

	opts = {
		highlight = {
			on_put = true,
			on_yank = true,
			timer = 100,
		},
		preserve_cursor_position = {
			enabled = true,
		},
		system_clipboard = {
			sync_with_ring = false,
		},
	},

	keys = {
		{ 'p', '<Plug>(YankyPutAfter)', desc = 'Put after' },
		{ 'P', '<Plug>(YankyPutBefore)', desc = 'Put before' },
		{ '<C-p>', '<Plug>(YankyPreviousEntry)', desc = 'Cycle to previous clipboard entry' },
		{ '<C-n>', '<Plug>(YankyNextEntry)', desc = 'Cycle to next clipboard entry' },
	},
}
