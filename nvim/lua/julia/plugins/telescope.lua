local utils = require 'julia.utils'
local keymap = utils.keymap

return {
	{
		'nvim-telescope/telescope.nvim',
		branch = 'master',
		cmd = 'Telescope',
		event = 'BufWinEnter',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		config = function()
			local telescope = require 'telescope'

			telescope.setup {
				defaults = {
					layout_strategy = 'horizontal',
					-- Make telescope pickers fullscreen
					layout_config = {
						width = function(_, cols, _)
							return cols - 2
						end,
						height = function(_, _, rows)
							return rows - 2
						end,
					},
				},
			}

			local builtin = require 'telescope.builtin'
			local picker_opts = {
				hidden = true,
				no_ignore = true,
			}

			local find_files = utils.wrap_fn(builtin.find_files, picker_opts)
			local live_grep = utils.wrap_fn(builtin.live_grep, picker_opts)
			local git_files =
				utils.wrap_fn(builtin.git_files, vim.tbl_extend('force', picker_opts, { show_untracked = true }))

			keymap('n', '<leader>pf', git_files)
			keymap('n', '<leader>af', find_files)
			keymap('n', '<leader>gs', live_grep)
			keymap('n', '<leader>rf', builtin.lsp_references)
			keymap('n', '<leader>gc', builtin.git_commits)
			keymap('n', '<leader>ts', builtin.treesitter)
			keymap('n', '<leader>pr', builtin.diagnostics)
			keymap('n', '<leader>ht', builtin.help_tags)
		end,
	},
}
