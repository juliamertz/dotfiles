return {
	'gbprod/yanky.nvim',
	event = 'BufEnter',
	opts = {
		highlight = { timer = 150 },
	},
	keys = {
		{
			'<leader>pp',
			function()
				require('telescope').extensions.yank_history.yank_history {}
			end,
			mode = { 'n', 'x' },
			desc = 'Open Yank History',
		},

		{ 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank Text' },
		{ 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put Text After Cursor' },
		{ 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put Text Before Cursor' },
		{ '<C-p>', '<Plug>(YankyCycleForward)', desc = 'Cycle Forward Through Yank History' },
		{ '<C-n>', '<Plug>(YankyCycleBackward)', desc = 'Cycle Backward Through Yank History' },
	},
}
