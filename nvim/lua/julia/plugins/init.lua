return {
	{
		'stevearc/oil.nvim',
		-- dependencies = { { 'echasnovski/mini.icons', opts = {} } },
		opts = {},
		keys = {
			{
				'<leader>ef',
				':Oil<CR>',
				desc = 'Open oil-nvim file explorer',
			},
		},
	},

	-- {
	-- 	'uga-rosa/ccc.nvim',
	-- 	opts = {
	-- 		highlighter = {
	-- 			auto_enable = true,
	-- 			lsp = true,
	-- 		},
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			'<leader>cc',
	-- 			':CccConvert<CR>',
	-- 			desc = 'Open color converter',
	-- 		},
	-- 		{
	-- 			'<leader>cp',
	-- 			':CccPick<CR>',
	-- 			desc = 'Open color picker',
	-- 		},
	-- 	},
	-- },

	--
	-- {
	-- 	'mrcjkb/rustaceanvim',
	-- 	version = '^5',
	-- 	lazy = false,
	-- },

	{
		'MeanderingProgrammer/render-markdown.nvim',
		opts = {},
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
	},
}
