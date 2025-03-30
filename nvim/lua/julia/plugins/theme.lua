return {
	'rose-pine/neovim',
	name = 'rose-pine',
	enabled = require('utils').enableForCat 'theme',

	opts = {
		variant = 'moon',
		dim_inactive_windows = false,
		styles = {
			bold = false,
			italic = false,
			transparency = true,
		},
	},

	init = function()
		vim.cmd 'colorscheme rose-pine-moon'
	end,
}
