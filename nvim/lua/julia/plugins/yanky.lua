return {
	'gbprod/yanky.nvim',
	opts = {
		highlight = {
			on_put = true,
			on_yank = true,
			timer = 150,
		},
	},

	keys = {
		{
			'p',
			'<Plug>(YankyPutAfter)',
			mode = { 'n', 'x' },
			desc = 'Paste after',
		},
		{
			'P',
			'<Plug>(YankyPutBefore)',
			mode = { 'n', 'x' },
			desc = 'Paste before',
		},
		{
			'<c-p>',
			'<Plug>(YankyPreviousEntry)',
			mode = 'n',
			desc = 'Cycle to previous clipboard entry',
		},
		{
			'<c-n>',
			'<Plug>(YankyNextEntry)',
			mode = 'n',
			desc = 'Cycle to next clipboard entry',
		},
		{
			'<leader>pp',
      function ()
        require('telescope').extensions.yank_history.yank_history {}
      end,
			mode = 'n',
			desc = 'Open clipboard history in telescope picker',
		},
	},
}
