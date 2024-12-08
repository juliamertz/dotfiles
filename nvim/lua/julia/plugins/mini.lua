return {
	{
		"echasnovski/mini.nvim",
		dependencies = { "folke/snacks.nvim" },

		config = function()
			require("mini.icons").setup()
			require("mini.surround").setup()
			require("mini.pairs").setup()
			require("mini.align").setup()

			require("mini.files").setup()
			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesActionRename",
				callback = function(event)
					Snacks.rename.on_rename_file(event.data.from, event.data.to)
				end,
			})
		end,
	},
}
