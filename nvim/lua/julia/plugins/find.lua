local utils = require 'utils'

local function picker_cmd(args)
	return '<cmd>Telescope ' .. args .. '<CR>'
end

return {
	'nvim-telescope/telescope.nvim',
	event = 'VimEnter',

	enabled = utils.enableForCat 'fuzzyfinder',

	dependencies = {
		'nvim-lua/plenary.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = utils.lazyAdd 'make',
			cond = utils.lazyAdd(function()
				return vim.fn.executable 'make' == 1
			end),
		},
		{ 'nvim-telescope/telescope-ui-select.nvim' },
	},

	config = function()
		require('telescope').setup {
			extensions = {
				['ui-select'] = {
					require('telescope.themes').get_dropdown(),
				},
			},
			defaults = {
				layout_strategy = 'horizontal',
				layout_config = {
					preview_cutoff = 64,
					width = function(_, cols, _)
						return cols
					end,
					height = function(_, _, rows)
						return rows
					end,
					preview_width = function(_, cols, _)
						return math.floor((cols / 5) * 3)
					end,
				},
			},
		}

		pcall(require('telescope').load_extension, 'fzf')
		pcall(require('telescope').load_extension, 'ui-select')
	end,

	keys = {
		{ '<leader>ht', picker_cmd 'help_tags', desc = 'Search help tags' },
		{ '<leader>pf', picker_cmd 'find_files hidden=true no_ignore=true', desc = 'Find files' },
		{ '<leader>gs', picker_cmd 'live_grep hidden=true no_ignore=true', desc = 'Live grep' },
		{ '<leader>vws', picker_cmd 'lsp_workspace_symbols', desc = 'View LSP workspace symbols' },
	},
}
