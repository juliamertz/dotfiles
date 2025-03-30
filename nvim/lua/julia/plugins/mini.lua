return {
	{
		'echasnovski/mini.surround',
		opts = {},
	},

	{
		'echasnovski/mini.comment',
		opts = {},
	},

	{
		'echasnovski/mini.icons',
		config = function()
			local icons = require 'mini.icons'
			icons.mock_nvim_web_devicons()
		end,
	},

	{
		'echasnovski/mini.statusline',
		opts = {
			content = {
				inactive = nil,
				active = function()
					local check_macro_recording = function()
						if vim.fn.reg_recording() ~= '' then
							return 'Recording @' .. vim.fn.reg_recording()
						else
							return ''
						end
					end

					local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
					local git = MiniStatusline.section_git { trunc_width = 40 }
					local diff = MiniStatusline.section_diff { trunc_width = 75 }
					local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
					local filename = MiniStatusline.section_filename { trunc_width = 140 }
					local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
					local location = MiniStatusline.section_location { trunc_width = 200 }
					local search = MiniStatusline.section_searchcount { trunc_width = 75 }
					local macro = check_macro_recording()

					return MiniStatusline.combine_groups {
						{ hl = mode_hl, strings = { mode } },
						{ hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
						'%<', -- Mark general truncate point
						{ hl = 'MiniStatuslineFilename', strings = { filename } },
						'%=', -- End left alignment
						{ hl = 'MiniStatuslineFilename', strings = { macro } },
						{ hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
						{ hl = mode_hl, strings = { search, location } },
					}
				end,
			},
			use_icons = nixCats 'have_nerd_font',
		},
		init = function()
			-- Disable statusline for certain filetypes
			vim.api.nvim_create_autocmd('Filetype', {
				callback = function(args)
					local disabled_filetypes = { 'man', 'NvimTree', 'oil' }
					if vim.tbl_contains(disabled_filetypes, vim.bo[args.buf].filetype) then
						vim.b[args.buf].ministatusline_disable = true
					end
				end,
			})
		end,
	},
}
