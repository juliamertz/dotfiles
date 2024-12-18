return {
	'nvim-tree/nvim-tree.lua',
	event = 'VeryLazy',
	dependencies = { 'echasnovski/mini.icons' },

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
