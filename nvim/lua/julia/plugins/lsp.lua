local utils = require 'utils'

return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{
				'williamboman/mason.nvim',
				enabled = utils.lazyAdd(true, false),
				config = true,
			}, -- NOTE: Must be loaded before dependants
			{
				'williamboman/mason-lspconfig.nvim',
				enabled = utils.lazyAdd(true, false),
			},
			{
				'WhoIsSethDaniel/mason-tool-installer.nvim',
				enabled = utils.lazyAdd(true, false),
			},

			-- LSP Status messages
			-- { "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)
					local builtin = require 'telescope.builtin'
					local map = function(keys, func, desc)
						vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
					end
					map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
					map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
					map('gr', builtin.lsp_references, '[G]oto [R]eferences')
					map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
					map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
					map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
					map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
					map('K', vim.lsp.buf.hover, 'Hover Documentation')

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup =
							vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
						vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd('LspDetach', {
							group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
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

			local configs = require 'lspconfig.configs'
			local util = require 'lspconfig.util'
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

			local servers = {}

			if utils.enableForCat 'nix' then
				if utils.isNixCats then
					servers.nixd = {}
				else
					servers.rnix = {}
					servers.nil_ls = {}
				end
			end

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

			servers.kcl = utils.ifCat('kcl', {})

			servers.zls = utils.ifCat('zig', {})

			servers.basedpyright = utils.ifCat('python', {})

			servers.gopls = utils.ifCat('go', {})

			if utils.enableForCat 'javascript' then
				servers.denols = {
					on_attach = on_attach,
					root_dir = require('lspconfig').util.root_pattern('deno.json', 'deno.jsonc'),
				}
				-- servers.ts_ls = {
				-- 	on_attach = on_attach,
				-- 	root_dir = require('lspconfig').util.root_pattern 'package.json',
				-- 	single_file_support = false,
				-- }

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

			configs.protobuf_language_server = {
				default_config = {
					cmd = { 'protobuf-language-server' },
					filetypes = { 'proto', 'cpp' },
					root_dir = util.root_pattern '.git',
					single_file_support = true,
					settings = {
						['additional-proto-dirs'] = '',
					},
				},
			}

			servers.protobuf_language_server = {}
			servers.prismals = {}

			if utils.isNixCats then
				for server_name, _ in pairs(servers) do
					require('lspconfig')[server_name].setup {
						capabilities = capabilities,
						settings = (servers[server_name] or {}).settings,
						filetypes = (servers[server_name] or {}).filetypes,
						cmd = (servers[server_name] or {}).cmd,
						root_pattern = (servers[server_name] or {}).root_pattern,
					}
				end
			else
				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, { 'stylua' })

				require('mason').setup()
				require('mason-tool-installer').setup { ensure_installed = ensure_installed }
				require('mason-lspconfig').setup {
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							server.capabilities =
								vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
							require('lspconfig')[server_name].setup(server)
						end,
					},
				}
			end
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

	{
		'kcl-lang/kcl.nvim',
	},
}
