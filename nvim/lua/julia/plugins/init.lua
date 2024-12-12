return {
	{ "folke/todo-comments.nvim" },

	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("oil").setup({})
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<leader>ef", ":Oil<CR>", opts)
		end,
	},
}
