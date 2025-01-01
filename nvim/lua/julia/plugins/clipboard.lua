return {
  enable = false,
	'gbprod/yanky.nvim',
	event = 'BufEnter',
	opts = {
		highlight = { timer = 150 },
		ring = {
			ignore_registers = { '_', '+', '*' },
		},
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
	-- When connected through ssh neovim will constantly print 'OSC 52 waiting for clipboard'
	-- this is a temporary workaround...
	init = function()
		-- vim.o.clipboard = 'unnamedplus'
		--
		-- local function paste()
		-- 	return {
		-- 		vim.fn.split(vim.fn.getreg '', '\n'),
		-- 		vim.fn.getregtype '',
		-- 	}
		-- end

		vim.g.clipboard = {
			name = 'OSC 52',
			copy = {
				['+'] = require('vim.ui.clipboard.osc52').copy '+',
				['*'] = require('vim.ui.clipboard.osc52').copy '*',
			},
			paste = {
				['+'] = paste,
				['*'] = paste,
			},
		}
	end,
}
