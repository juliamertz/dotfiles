local keymap = require('julia.utils').keymap

return {
	'stevearc/conform.nvim',
	config = function()
		local conform = require 'conform'
		local function format()
			conform.format {
				async = true,
				bufnr = 0,
				lsp_fallback = true,
			}
		end

		vim.api.nvim_create_user_command('Format', format, {})
		keymap('n', '<leader>ff', format)

		conform.setup {
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
				-- toml = { "taplo" },
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
		}
	end,
}
