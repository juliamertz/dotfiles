return {
	'stevearc/conform.nvim',
	config = function()
		local conform = require 'conform'
		conform.setup {
			formatters_by_ft = {
				lua = { 'stylua' },
				javascript = { { 'prettierd', 'prettier' } },
				typescript = { { 'prettierd', 'prettier' } },
				astro = { { 'prettierd', 'prettier' } },
				typescriptreact = { 'rustywind', { 'prettierd', 'prettier' } },
				go = { 'gofumpt' },
				markdown = { 'markdownlint' },
				python = { 'ruff_format' },
				rust = { 'rustfmt' },
				handlebars = { 'prettier' },
				sql = { 'sql-formatter' },
				nix = { 'nixfmt' },
				-- toml = { "taplo" },
			},
			formatters = {
				taplo = {
					command = 'taplo',
					args = {
						'fmt',
						'--option',
						'align_entries=true',
						'$FILENAME',
					},
					stdin = false,
				},
				stylua = {
					command = 'stylua',
					args = {
						'$FILENAME',
						'--call-parentheses None',
						'--collapse-simple-statement Always',
						'--column-width 80',
						'--quote-style AutoPreferSingle',
					},
					stdin = false,
				},
				nixfmt = {
					command = 'nixfmt',
					args = { '$FILENAME' },
					stdin = false,
				},
				['sql-formatter'] = {
					command = 'sql-formatter',
					args = { '$FILENAME' },
					stdin = true,
				},
			},
		}

		vim.api.nvim_create_autocmd('BufWritePre', {
			callback = function(args)
				require('conform').format {
					bufnr = args.buf,
					lsp_fallback = true,
					quiet = true,
				}
			end,
		})
	end,
}
