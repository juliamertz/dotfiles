return {
	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,

		opts = {
			bigfile = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			rename = { enabled = true },
		},

		init = function()
			vim.api.nvim_create_autocmd('User', {
				pattern = 'MiniFilesActionRename',
				callback = function(event)
					require('snacks').rename.on_rename_file(event.data.from, event.data.to)
				end,
			})
		end,
	},

	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {},
	},

	'folke/noice.nvim',
	dependencies = { 'MunifTanjim/nui.nvim' },
	event = 'VeryLazy',
	opts = {
		lsp = {
			hover = {
				enabled = false,
			},
			signature = {
				enabled = false,
			},
			presets = {
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
	},

	{
		'folke/trouble.nvim',
		keys = {
			{
				'<leader>pr',
				'<cmd>Trouble diagnostics toggle<cr>',
				desc = 'Diagnostics (Trouble)',
			},
			{
				'<leader>vrr',
				'<cmd>Trouble lsp_references toggle<cr>',
				desc = 'Symbols (Trouble)',
			},
			{
				'<leader>cs',
				'<cmd>Trouble symbols toggle<cr>',
				desc = 'Symbols (Trouble)',
			},
			{
				'<leader>td',
				'<cmd>Trouble todo toggle<cr>',
				desc = 'Symbols (Trouble)',
			},
		},
		opts = {
			focus = true,
			warn_no_results = false,
			open_no_results = true,
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
	},

	{
		'folke/lazydev.nvim',
		event = 'BufEnter',
		ft = 'lua',
		opts = {
			library = {
				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
			},
		},
	},
}
