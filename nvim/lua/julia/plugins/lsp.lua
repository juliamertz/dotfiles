return {
	{
		'VonHeikemen/lsp-zero.nvim',
		event = 'BufRead',
		branch = 'v2.x',
		dependencies = {
			{ 'onsails/lspkind.nvim' },
			{ 'neovim/nvim-lspconfig' }, -- Required
			{ 'williamboman/mason.nvim' }, -- Optional
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'L3MON4D3/LuaSnip' }, -- Required
			{ 'folke/neodev.nvim', opts = {} },
		},
		config = function()
			require('neodev').setup {}
			require('mason').setup { PATH = 'append' }

			local lsp = require 'lsp-zero'
			lsp.preset 'recommended'

			local binds = require 'julia.binds'

			local lspconfig = require 'lspconfig'
			-- lspconfig.lua_ls.setup({
			-- 	settings = {
			-- 		Lua = {
			-- 			completion = {
			-- 				callSnippet = "Replace",
			-- 			},
			-- 		},
			-- 	},
			-- })
			--
			lspconfig.gopls.setup {}
			lspconfig.htmx.setup { filetypes = { 'html', 'htmlaskama', 'htmldjango' } }
			lspconfig.tailwindcss.setup { filetypes = { 'html', 'htmlaskama', 'htmldjango' } }

			-- temporary fix for rust-analzyer throwing errors
			for _, method in ipairs { 'textDocument/diagnostic', 'workspace/diagnostic' } do
				local default_diagnostic_handler = vim.lsp.handlers[method]
				vim.lsp.handlers[method] = function(err, result, context, config)
					if err ~= nil and err.code == -32802 then
						return
					end
					return default_diagnostic_handler(err, result, context, config)
				end
			end

			local cmp = require 'cmp'
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local cmp_mappings = lsp.defaults.cmp_mappings {
				[binds.cmp.select_prev_item] = cmp.mapping.select_prev_item(cmp_select),
				[binds.cmp.select_next_item] = cmp.mapping.select_next_item(cmp_select),
				[binds.cmp.confirm] = cmp.mapping.confirm { select = true },
				[binds.cmp.complete] = cmp.mapping.complete(),
			}

			cmp.config.formatting = {
				format = require('lspkind').cmp_format {
					before = require('tailwind-tools.cmp').lspkind_format,
				},
			}

			cmp_mappings['<Tab>'] = nil
			cmp_mappings['<S-Tab>'] = nil

			lsp.setup_nvim_cmp { mapping = cmp_mappings }

			lsp.on_attach(function(_, bufnr)
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set('n', binds.lsp.definition, vim.lsp.buf.definition, opts)
				vim.keymap.set('n', binds.lsp.hover, vim.lsp.buf.hover, opts)
				vim.keymap.set(
					'n',
					binds.lsp.workspace_symbol,
					require('telescope.builtin').lsp_workspace_symbols,
					opts
				)
				vim.keymap.set('n', binds.lsp.open_float, vim.diagnostic.open_float, opts)
				vim.keymap.set('n', binds.lsp.goto_next, vim.diagnostic.goto_next, opts)
				vim.keymap.set('n', binds.lsp.goto_prev, vim.diagnostic.goto_prev, opts)
				vim.keymap.set('n', binds.lsp.code_action, vim.lsp.buf.code_action, opts)
				vim.keymap.set('n', binds.lsp.rename, vim.lsp.buf.rename, opts)
				vim.keymap.set('i', binds.lsp.signature_help, vim.lsp.buf.signature_help, opts)
			end)

			lsp.setup()

			vim.diagnostic.config {
				virtual_text = true,
			}
		end,
	},
	{
		'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
		config = function()
			local tld = require 'toggle_lsp_diagnostics'
			tld.init {}
			vim.keymap.set('n', '<leader>td', '<plug>(toggle-lsp-diag-vtext)')
		end,
	},
	{
		'nvimtools/none-ls.nvim',
		event = 'BufRead',
		opts = {},
	},
}
-- local keymap = require('julia.utils').keymap
--
-- return {
-- 	{
-- 		'folke/lazydev.nvim',
-- 		event = 'BufEnter',
-- 		ft = 'lua',
-- 		opts = {
-- 			library = {
-- 				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
-- 			},
-- 		},
-- 	},
--
-- 	{
-- 		'neovim/nvim-lspconfig',
-- 		event = 'BufEnter',
-- 		dependencies = {
-- 			{ 'j-hui/fidget.nvim', opts = {} },
-- 			'williamboman/mason-lspconfig.nvim',
-- 			'WhoIsSethDaniel/mason-tool-installer.nvim',
-- 			'b0o/SchemaStore.nvim',
-- 		},
-- 		config = function()
-- 			local capabilities = nil
-- 			if pcall(require, 'cmp_nvim_lsp') then
-- 				capabilities = require('cmp_nvim_lsp').default_capabilities()
-- 			end
--
-- 			local lspconfig = require 'lspconfig'
--
-- 			local servers = {
-- 				lua_ls = true,
-- 				rust_analyzer = true,
-- 				clangd = {
-- 					init_options = { clangdFileStatus = true },
-- 					filetypes = { 'c' },
-- 				},
-- 			}
--
-- 			local servers_to_install = vim.tbl_filter(function(key)
-- 				local t = servers[key]
-- 				if type(t) == 'table' then
-- 					return not t.manual_install
-- 				else
-- 					return t
-- 				end
-- 			end, vim.tbl_keys(servers))
--
-- 			require('mason').setup()
-- 			local ensure_installed = {
-- 				'stylua',
-- 				'lua_ls',
-- 			}
--
-- 			vim.list_extend(ensure_installed, servers_to_install)
-- 			require('mason-tool-installer').setup {
-- 				ensure_installed = ensure_installed,
-- 			}
--
-- 			for name, config in pairs(servers) do
-- 				if config == true then
-- 					config = {}
-- 				end
-- 				config = vim.tbl_deep_extend('force', {}, {
-- 					capabilities = capabilities,
-- 				}, config)
--
-- 				lspconfig[name].setup(config)
-- 			end
--
-- 			local disable_semantic_tokens = {
-- 				lua = true,
-- 			}
--
-- 			vim.api.nvim_create_autocmd('LspAttach', {
-- 				callback = function(args)
-- 					local bufnr = args.buf
-- 					local client = assert(vim.lsp.get_client_by_id(args.data.client_id), 'must have valid client')
--
-- 					vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'
-- 					local opts = { buffer = 0 }
-- 					keymap('n', 'gd', vim.lsp.buf.definition, opts)
-- 					keymap('n', 'vrr', vim.lsp.buf.references, opts)
-- 					keymap('n', 'gD', vim.lsp.buf.declaration, opts)
-- 					keymap('n', 'gT', vim.lsp.buf.type_definition, opts)
-- 					keymap('n', 'K', vim.lsp.buf.hover, opts)
--
-- 					keymap('n', '<space>cr', vim.lsp.buf.rename, opts)
-- 					keymap('n', '<space>ca', vim.lsp.buf.code_action, opts)
--
-- 					local filetype = vim.bo[bufnr].filetype
-- 					if disable_semantic_tokens[filetype] then
-- 						client.server_capabilities.semanticTokensProvider = nil
-- 					end
-- 				end,
-- 			})
-- 		end,
-- 	},
-- }
