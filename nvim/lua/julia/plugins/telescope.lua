local utils = require("julia.utils")

return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		cmd = "Telescope",
		event = "BufWinEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					layout_strategy = "horizontal",
          -- Make telescope pickers fullscreen
					layout_config = {
						width = function(_, cols, _)
							return cols
						end,
						height = function(_, _, rows)
							return rows
						end,
					},
				},
			})

			local builtin = require("telescope.builtin")
			local picker_opts = {
				hidden = true,
				no_ignore = true,
			}

			local find_files = utils.wrap_fn(builtin.find_files, picker_opts)
			local live_grep = utils.wrap_fn(builtin.live_grep, picker_opts)
			local git_files = utils.wrap_fn(builtin.git_files, { show_untracked = true })

			local keymap = vim.keymap.set
			local opts = {
				noremap = true,
				silent = true,
			}

			keymap("n", "<leader>pf", git_files, opts)
			keymap("n", "<leader>af", find_files, opts)
			keymap("n", "<leader>gs", live_grep, opts)
			keymap("n", "<leader>rf", builtin.lsp_references, opts)
			keymap("n", "<leader>gc", builtin.git_commits, opts)
			keymap("n", "<leader>ts", builtin.treesitter, opts)
			keymap("n", "<leader>ht", builtin.help_tags, opts)
		end,
	},
	{
		"piersolenski/telescope-import.nvim",
		dependencies = "nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").load_extension("import")
		end,
	},
}
