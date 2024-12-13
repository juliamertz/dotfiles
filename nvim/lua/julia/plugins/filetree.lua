return {
	'nvim-tree/nvim-tree.lua',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	event = 'VeryLazy',

	keys = {
		{ '<C-b>', ':NvimTreeToggle<CR>', mode = 'n', desc = 'Toggle file tree' },
	},

	opts = {
		sort_by = 'extension',
		view = {
			side = 'right',
			width = 30,
		},
		renderer = {
			group_empty = true,
		},
		filters = {
			dotfiles = false,
		},
	},
}
