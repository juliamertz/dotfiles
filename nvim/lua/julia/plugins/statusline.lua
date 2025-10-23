return {
	{
		'echasnovski/mini.statusline',
		dependencies = { 'echasnovski/mini.icons' },
		opts = {
			content = {
				inactive = nil,
				active = function()
					local icons = require 'mini.icons'

					local check_macro_recording = function()
						if vim.fn.reg_recording() ~= '' then
							return 'Recording @' .. vim.fn.reg_recording()
						else
							return ''
						end
					end

					local section_fileinfo = function()
						local filetype = vim.bo.filetype
						local icon = icons.get('filetype', filetype)
						local text = ''

						if filetype ~= '' and icon ~= nil then
							return icon .. ' ' .. filetype
						end

						if icon ~= nil then
							return icon
						end

						return filetype
					end

					local section_filename = function()
						if vim.bo.buftype == 'terminal' then
							return '%t'
						else
							return '%f%m%r'
						end
					end

					local _, mode_hl = MiniStatusline.section_mode { trunc_width = 20 }
					local fileinfo = section_fileinfo()
					local macro = check_macro_recording()
					local location = MiniStatusline.section_location { trunc_width = 20 }
					local filename = section_filename()

					return MiniStatusline.combine_groups {
						'%<', -- Mark general truncate point
						'%=', -- End left alignment
						{ hl = 'MiniStatuslineFilename', strings = { filename } },
						{ hl = 'MiniStatuslineOther', strings = { macro } },
						{ hl = 'MiniStatuslineLocation', strings = { location } },
						{ hl = mode_hl, strings = { fileinfo } },
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

	{
		'vimpostor/vim-tpipeline',
		init = function()
			vim.g.tpipeline_embedopts = {
				[[ status-right '#(cat #{socket_path}-\#{session_id}-vimbridge-R)' ]],
				[[ status-right-length 99 ]],
			}

			if vim.env.TMUX then
				vim.opt.laststatus = 0
				vim.g.tpipeline_autoembed = 1
			else
				vim.g.tpipeline_autoembed = 0
			end
		end,
	},
}
