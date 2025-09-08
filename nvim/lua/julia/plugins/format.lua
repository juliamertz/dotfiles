local utils = require 'utils'

return {
	'stevearc/conform.nvim',

	opts = {
		formatters_by_ft = {
			lua = utils.optionalCat('lua', { 'stylua' }),
			python = utils.optionalCat('python', { 'black' }),
			nix = utils.optionalCat('nix', { 'alejandra', 'nixfmt' }),
			rust = utils.optionalCat('rust', { 'rustfmt', lsp_format = 'fallback' }),
			zig = utils.optionalCat('zig', { 'zigfmt', lsp_format = 'fallback' }),
			go = utils.optionalCat('go', { 'gofumpt', lsp_format = 'fallback' }),
			javascript = utils.optionalCat('javascript', { 'biome', lsp_format = 'fallback' }),
			ocaml = utils.optionalCat('ocaml', { 'ocamlformat' }),
			yaml = utils.optionalCat('yaml', { 'yamlfmt' }),
			kcl = utils.optionalCat('kcl', { 'kcl' }),
		},

		formatters = {
			ocamlformat = utils.ifCat('ocaml', {
				command = 'ocamlformat',
				stdin = false,
				args = {
					'--inplace',
					'--enable-outside-detected-project',
					'-p',
					'janestreet',
					'$FILENAME',
				},
			}),
			stylua = utils.ifCat('lua', {
				command = 'stylua',
				stdin = false,
				args = {
					'$FILENAME',
					'--call-parentheses',
					'None',
					'--quote-style',
					'AutoPreferSingle',
				},
			}),
			kcl = utils.ifCat('kcl', {
				command = 'kcl',
				stdin = false,
				args = {
					'fmt',
					'$FILENAME',
				},
			}),
		},
	},

	init = function()
		local conform = require 'conform'

		vim.api.nvim_create_user_command('Format', function()
			conform.format {
				async = true,
				bufnr = 0,
				lsp_fallback = true,
			}
		end, {})
	end,

	keys = {
		{ '<leader>ff', '<cmd>Format<cr>', desc = 'Format current buffer' },
	},
}
