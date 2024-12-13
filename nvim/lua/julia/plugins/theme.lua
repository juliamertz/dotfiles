return {
	'rose-pine/neovim',
	name = 'rose-pine',
	opts = {
		variant = 'moon',
		styles = {
			bold = false,
			italic = false,
			transparency = true,
		},
	},
	init = function()
		vim.cmd 'colorscheme rose-pine'
	end,
}
