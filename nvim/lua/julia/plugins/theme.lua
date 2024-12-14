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

	{
		'nvim-lualine/lualine.nvim',
		event = 'ColorScheme',
		dependencies = { 'echasnovski/mini.icons' },
		opts = {
			disabled_filetypes = { 'man', 'NvimTree' },
			options = {
				theme = 'rose-pine',
				component_separators = '|',
				section_separators = { left = '', right = '' },
			},
			sections = {
				lualine_a = {
					{ 'mode', separator = { left = '' }, right_padding = 2 },
				},
				lualine_b = { 'filename', 'branch' },
				lualine_c = { 'fileformat' },
				lualine_x = {
					{
						function()
							local reg = vim.fn.reg_recording()
							if reg == '' then
								return ''
							end
							return 'recording to ' .. reg
						end,
					},
				},
				lualine_y = { 'filetype', 'progress' },
				lualine_z = {
					{ 'location', separator = { right = '' }, left_padding = 2 },
				},
			},
			inactive_sections = {
				lualine_a = { 'filename' },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { 'location' },
			},
			tabline = {},
			extensions = {},
		},
	},
}
