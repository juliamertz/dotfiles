local utils = require 'utils'

return {
	'fredrikaverpil/godoc.nvim',
	enable = utils.enableForCat 'docs',

	dependencies = {
		{
			'juliamertz/noogle-cli',
			name = 'noogle.nvim',
			enable = utils.isNixCats and utils.enableForCat 'nix',
		},
	},

	opts = {
		adapters = {
			utils.optional(utils.enableForCat 'go', {
				name = 'go',
			}),
			utils.optional(utils.isNixCats and utils.enableForCat 'nix', {
				name = 'nix',
				setup = function()
					return require('noogle').setup()
				end,
			}),
		},
		picker = {
			type = 'telescope',
			telescope = {},
		},
		window = {
			type = 'vsplit',
		},
	},

	keys = {
		{
			'<leader>gd',
			'<cmd>GoDoc<CR>',
			desc = 'Search Go documentation',
		},
		{
			'<leader>nd',
			'<cmd>Noogle<CR>',
			desc = 'Search Nixpkgs documentation',
		},
	},
}
