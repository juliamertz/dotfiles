return {

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		event = 'VeryLazy',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = {
					'lua',
					'vim',
					'vimdoc',
					'query',
					'javascript',
					'go',
					'rust',
					'json',
					'http',
					'css',
					'html',
					'yaml',
					'sql',
				},
				ignore_install = {},
				modules = {},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			}
		end,
	},

	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		event = 'VeryLazy',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function(one, two)
			require('nvim-treesitter.configs').setup {
				textobjects = {
					swap = {
						enable = true,
						swap_next = {
							['<leader>na'] = '@parameter.inner',
							['<leader>nm'] = '@function.outer',
						},
						swap_previous = {
							['<leader>pa'] = '@parameter.inner',
							['<leader>pm'] = '@function.outer',
						},
					},
				},
			}
		end,
	},

	{
		'windwp/nvim-ts-autotag',
		event = 'BufRead',
		config = function()
			require('nvim-ts-autotag').setup {
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
				aliases = {
					['handlebars'] = 'html',
				},
			}
		end,
	},
}
