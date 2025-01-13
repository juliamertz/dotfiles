return {
	'jiaoshijie/undotree',
	dependencies = 'nvim-lua/plenary.nvim',

	keys = {
		{ '<leader>ut', ':UndoTreeToggle<CR>', desc = 'Toggle undotree pane' },
	},

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
		keymaps = {
			['j'] = 'move_next',
			['k'] = 'move_prev',
			['gj'] = 'move2parent',
			['J'] = 'move_change_next',
			['K'] = 'move_change_prev',
			['<cr>'] = 'action_enter',
			['p'] = 'enter_diffbuf',
			['q'] = 'quit',
		},
	},

	init = function()
		vim.api.nvim_create_user_command('UndoTreeToggle', function()
			require('undotree').toggle()
		end, {})
	end,
}
