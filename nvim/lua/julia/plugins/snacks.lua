return {
	'folke/snacks.nvim',
	priority = 1000,
	lazy = false,

	config = function()
		local snacks = require 'snacks'
		snacks.setup {
			bigfile = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			rename = { enabled = true },
		}

		vim.api.nvim_create_autocmd('User', {
			pattern = 'MiniFilesActionRename',
			callback = function(event)
				Snacks.rename.on_rename_file(event.data.from, event.data.to)
			end,
		})
	end,
}
