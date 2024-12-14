return {
	{
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
			vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
			vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
			vim.cmd 'hi Normal guibg=none ctermbg=none'
			vim.cmd 'colorscheme rose-pine'
		end,
	},
}
