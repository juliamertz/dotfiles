local utils = require 'utils'

return {
	'fredrikaverpil/godoc.nvim',
	enabled = utils.enableForCat 'docs' and (utils.enableForCat 'nix' or utils.enableForCat 'go'),

	dependencies = {
		{
			'juliamertz/noogle-cli',
			name = 'noogle.nvim',
			enabled = utils.isNixCats and utils.enableForCat 'nix',
		},
	},

	config = function()
		local godoc = require 'godoc'
		local adapters = {}

		if utils.enableForCat 'go' then
			table.insert(adapters, {
				name = 'go',
			})
		end

		if utils.isNixCats and utils.enableForCat 'nix' then
			table.insert(adapters, {
				name = 'nix',
				setup = function()
					return require('noogle').setup()
				end,
			})
		end

		godoc.setup {
			adapters = adapters,
			picker = {
				type = 'telescope',
				telescope = {},
			},
			window = {
				type = 'vsplit',
			},
		}
	end,

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
