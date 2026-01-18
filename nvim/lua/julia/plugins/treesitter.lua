local utils = require 'utils'

return {
	'nvim-treesitter/nvim-treesitter',
	build = utils.lazyAdd ':TSUpdate',
	enabled = utils.enableForCat 'treesitter',

	opts = {
		ensure_installed = utils.lazyAdd {
			'bash',
			'c',
			'diff',
			'html',
			'lua',
			'luadoc',
			'markdown',
			'vim',
			'vimdoc',
		},
		auto_install = utils.lazyAdd(true, false),

		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { 'ruby' },
		},
		indent = { enable = true, disable = { 'ruby' } },
	},
	config = function(_, opts)
		require('nvim-treesitter.install').prefer_git = true
		---@diagnostic disable-next-line: missing-fields
		-- TODO: why did this break?
		-- require('nvim-treesitter.configs').setup(opts)
	end,
}
