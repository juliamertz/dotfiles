return {
	'stevearc/conform.nvim',
	event = 'BufEnter',

	keys = {
		{ '<leader>ff', ':Format<CR>', mode = 'n', desc = 'Format current buffer' },
	},

	init = function()
		vim.api.nvim_create_user_command('Format', function()
			require('conform').format {
				async = true,
				bufnr = 0,
				lsp_fallback = true,
			}
		end, {})
	end,

	opts = {
		formatters_by_ft = {
			lua = { 'stylua' },
			javascript = { 'prettier' },
			typescript = { 'prettier' },
			astro = { 'prettier' },
			typescriptreact = { 'rustywind', 'prettier' },
			go = { 'gofumpt' },
			markdown = { 'markdownlint' },
			python = { 'ruff_format' },
			rust = { 'rustfmt' },
			handlebars = { 'prettier' },
			sql = { 'sql-formatter' },
			nix = { 'nixfmt' },
		},
		formatters = {
			stylua = {
				command = 'stylua',
				args = {
					'$FILENAME',
					'--call-parentheses',
					'None',
					'--quote-style',
					'AutoPreferSingle',
				},
				stdin = false,
			},
			nixfmt = {
				command = 'nixfmt',
				args = { '$FILENAME' },
				stdin = false,
			},
		},
	},
}
