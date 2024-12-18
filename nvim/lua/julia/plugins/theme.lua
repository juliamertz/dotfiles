return {
	{
		'rose-pine/neovim',
		name = 'rose-pine',
		opts = {
			styles = {
				bold = false,
				italic = false,
				transparency = true,
			},
		},
		init = function()
			vim.cmd [[
        highlight Normal guibg=NONE ctermbg=none
        highlight NormalFloat guibg=NONE
        colorscheme rose-pine-moon
      ]]
		end,
	},
}
