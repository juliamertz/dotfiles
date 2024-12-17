return {
	{
		"echasnovski/mini.statusline",
		version = "*",
		opts = {
			content = {
				active = nil,
				inactive = nil,
			},
			use_icons = true,
			set_vim_settings = true,
		},
		init = function()
			vim.api.nvim_create_autocmd("Filetype", {
				callback = function(args)
					local disabled_filetypes = { "man", "NvimTree" }
					if vim.tbl_contains(disabled_filetypes, vim.bo[args.buf].filetype) then
						vim.b[args.buf].ministatusline_disable = true
					end
				end,
			})
		end,
	},
	{
		"echasnovski/mini.surround",
		version = "*",
		opts = {
			mappings = {
				add = "ys",
				delete = "ds",
				replace = "cs",
				find = "",
				find_left = "",
				highlight = "",
				update_n_lines = "",
				suffix_last = "",
				suffix_next = "",
			},
		},
	},
	{
		"echasnovski/mini.icons",
		opts = {},
		lazy = true,
		specs = {
			{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
}
