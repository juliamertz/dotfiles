local keymap = require("julia.utils").keymap

return {
	{
		"echasnovski/mini.nvim",
		dependencies = { "folke/snacks.nvim" },

		config = function()
			require("mini.icons").setup()
			require("mini.pairs").setup()
			require("mini.align").setup()

			require("mini.surround").setup({
				mappings = {
					add = "ys", -- Add surrounding in Normal and Visual modes
					delete = "ds", -- Delete surrounding
					replace = "cs", -- Replace surrounding

					find = "", -- Find surrounding (to the right)
					find_left = "", -- Find surrounding (to the left)
					highlight = "", -- Highlight surrounding
					update_n_lines = "", -- Update `n_lines`
					suffix_last = "", -- Suffix to search with "prev" method
					suffix_next = "", -- Suffix to search with "next" method
				},
			})

			local files = require("mini.files")
			files.setup()
			keymap("n", "<C-b>", function()
				local state = files.get_explorer_state()
				if state == nil then
					files.open()
				else
					files.close()
				end
			end)

			require("mini.statusline").setup({
				content = {
					active = nil,
					inactive = nil,
				},
				use_icons = true,
				set_vim_settings = true,
			})
		end,
	},
}
