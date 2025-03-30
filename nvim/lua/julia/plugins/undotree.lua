return {
	'mbbill/undotree',
	enable = require('utils').enableForCat 'undotree',

	opts = {
		float_diff = true,
		layout = 'left_bottom',
		position = 'left',
		ignore_filetype = {
			'undotree',
			'undotreeDiff',
			'qf',
			'TelescopePrompt',
			'spectre_panel',
			'tsplayground',
		},
		window = {
			winblend = 30,
		},
	},

	keys = {
		{ '<leader>ut', '<cmd>UndotreeToggle<CR>', desc = 'Toggle undotree' },
	},
}
