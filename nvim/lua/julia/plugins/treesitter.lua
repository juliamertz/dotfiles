return {
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		event = 'VeryLazy',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = {},
				ignore_install = {},
				modules = {},
				sync_install = false,
				auto_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			}
		end,
	},
}
