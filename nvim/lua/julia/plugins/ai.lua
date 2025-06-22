return {
	'supermaven-inc/supermaven-nvim',

	enabled = require('utils').enableForCat 'ai',

	opts = {
		keymaps = {
			accept_suggestion = '<C-y>',
			clear_suggestion = '<C-]>',
			accept_word = '<C-j>',
		},
		ignore_filetypes = { 'cpp' },
		color = {
			suggestion_color = '#666666',
			cterm = 244,
		},
		log_level = 'info', -- set to "off" to disable logging completely
		disable_inline_completion = false, -- disables inline completion for use with cmp
		disable_keymaps = false, -- disables built in keymaps for more manual control

		condition = function()
			local filepath = vim.fn.expand '%:p'
			local work_dir = vim.fn.expand '~/source/work'
			return vim.startswith(filepath, work_dir)
		end,
	},
}
