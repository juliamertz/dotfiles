return {
	'gbprod/yanky.nvim',

	keys = {
		{ 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put after' },
		{ 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put before' },
		{ '<C-p>', '<Plug>(YankyPreviousEntry)', mode = 'n', desc = 'Previous clipboard entry' },
		{ '<C-n>', '<Plug>(YankyNextEntry)', mode = 'n', desc = 'Next clipboard entry' },
		{
			'<leader>pp',
			function()
				require('telescope').extensions.yank_history.yank_history {}
			end,
			mode = { 'n', 'x' },
			desc = 'Put before',
		},
	},

	opts = {
		highlight = {
			on_put = true,
			on_yank = true,
			timer = 250,
		},
	},
}
