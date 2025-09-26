local utils = require 'utils'

return {
	{
		'neovim/nvim-lspconfig',

		config = function()
			local lsp_utils = require 'lspconfig.util'

			local servers = {}

			servers.nixd = utils.ifCat('nix', {})

			servers.bashls = utils.ifCat('shell', {
				cmd = { 'bash-language-server', 'start' },
				filetypes = { 'sh', 'bash', 'zsh' },
				settings = {
					bash = {
						shellcheck = {
							enable = true,
						},
					},
				},
			})

			if utils.enableForCat 'shell' then
				-- fix filetype detection for scripts with nix-shell shebang
				vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
					pattern = '*',
					callback = function()
						local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ''
						if first_line:match '^#!.*nix%-shell' then
							vim.bo.filetype = 'sh'
							vim.cmd 'LspStart bashls'
							if utils.enableForCat 'nix' and utils.isNixCats then
								vim.cmd 'LspStop nixd'
							end
						end
					end,
				})
			end

			if utils.enableForCat 'terraform' then
				-- neovim doesn't automatically recogize .tf files as hcl
				vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
					pattern = '*.tf',
					command = 'set filetype=hcl',
				})

				servers.terraformls = {}
			end

			if utils.enableForCat 'yaml' then
				servers.yamlls = {}
				servers.helm_ls = {}
			end

			servers.kcl = utils.ifCat('kcl', {})

			servers.zls = utils.ifCat('zig', {})

			servers.basedpyright = utils.ifCat('python', {})

			servers.gopls = utils.ifCat('go', {})

			if utils.enableForCat 'javascript' then
				servers.denols = { root_dir = lsp_utils.root_pattern('deno.json', 'deno.jsonc') }
				servers.ts_ls = { root_dir = lsp_utils.root_pattern 'package.json' }

				servers.astro = {}
				servers.svelte = {
					filetypes = { 'svelte' },
					capabilities = {
						workspace = { didChangeWatchedFiles = false },
					},
				}

				servers.tailwindcss = {
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ 'cva\\(((?:[^()]|\\([^()]*\\))*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
									{ 'cx\\(((?:[^()]|\\([^()]*\\))*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
								},
							},
						},
					},
				}
			end

			servers.rust_analyzer = utils.ifCat('rust', {})

			servers.ocamllsp = utils.ifCat('ocaml', {})

			servers.lua_ls = utils.ifCat('lua', {
				settings = {
					Lua = {
						completion = {
							callSnippet = 'Replace',
						},
						diagnostics = {
							globals = { 'nixCats' },
							disable = { 'missing-fields' },
						},
					},
				},
			})

			servers.protobuf_language_server = {
				cmd = { 'protobuf-language-server' },
				filetypes = { 'proto', 'cpp' },
				root_dir = lsp_utils.root_pattern '.git',
				single_file_support = true,
				settings = {
					['additional-proto-dirs'] = '',
				},
			}

			servers.protobuf_language_server = {}
			servers.prismals = {}

			if utils.isNixCats then
				for name, config in pairs(servers) do
					vim.lsp.enable(name)
					vim.lsp.config(name, {
						settings = config.settings or {},
						root_pattern = config.root_pattern,
						filetypes = config.filetypes,
						cmd = config.cmd,
						capabilities = vim.tbl_deep_extend(
							'force',
							vim.lsp.protocol.make_client_capabilities(),
							require('blink.cmp').get_lsp_capabilities(config.capabilities)
						),
					})
				end
			end

			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
				callback = function(event)
					local telescope = require 'telescope.builtin'
					local map = function(keys, func, desc)
						vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
					end

					map('gd', telescope.lsp_definitions, '[G]oto [D]efinition')
					map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
					map('gr', telescope.lsp_references, '[G]oto [R]eferences')
					map('gI', telescope.lsp_implementations, '[G]oto [I]mplementation')
					map('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinition')
					map('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
					map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
					map('K', vim.lsp.buf.hover, 'Hover Documentation')

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
						vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
							buffer = event.buf,
							group = highlight_group,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
							buffer = event.buf,
							group = highlight_group,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd('LspDetach', {
							group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
							end,
						})
					end

					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map('<leader>th', function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, '[T]oggle Inlay [H]ints')
					end
				end,
			})
		end,
	},

	{
		'folke/lazydev.nvim',
		enabled = utils.enableForCat 'lua',
		ft = 'lua',
		opts = {
			library = {
				{ path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
			},
		},
	},

	{ 'kcl-lang/kcl.nvim' },
}
