return {
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
}
