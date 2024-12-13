local keymap = require('julia.utils').keymap

return {
	{
		'folke/lazydev.nvim',
		event = 'BufEnter',
		ft = 'lua',
		opts = {
			library = {
				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
			},
		},
	},

	{
		'neovim/nvim-lspconfig',
		event = 'BufEnter',
		dependencies = {
			{ 'j-hui/fidget.nvim', opts = {} },
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			'b0o/SchemaStore.nvim',
		},
		config = function()
			local capabilities = nil
			if pcall(require, 'cmp_nvim_lsp') then
				capabilities = require('cmp_nvim_lsp').default_capabilities()
			end

			local lspconfig = require 'lspconfig'

			local servers = {
				lua_ls = true,
				rust_analyzer = true,
				clangd = {
					init_options = { clangdFileStatus = true },
					filetypes = { 'c' },
				},
			}

			local servers_to_install = vim.tbl_filter(function(key)
				local t = servers[key]
				if type(t) == 'table' then
					return not t.manual_install
				else
					return t
				end
			end, vim.tbl_keys(servers))

			require('mason').setup()
			local ensure_installed = {
				'stylua',
				'lua_ls',
			}

			vim.list_extend(ensure_installed, servers_to_install)
			require('mason-tool-installer').setup {
				ensure_installed = ensure_installed,
			}

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end
				config = vim.tbl_deep_extend('force', {}, {
					capabilities = capabilities,
				}, config)

				lspconfig[name].setup(config)
			end

			local disable_semantic_tokens = {
				lua = true,
			}

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local bufnr = args.buf
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id), 'must have valid client')

					vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'
					local opts = { buffer = 0 }
					keymap('n', 'gd', vim.lsp.buf.definition, opts)
					keymap('n', 'vrr', vim.lsp.buf.references, opts)
					keymap('n', 'gD', vim.lsp.buf.declaration, opts)
					keymap('n', 'gT', vim.lsp.buf.type_definition, opts)
					keymap('n', 'K', vim.lsp.buf.hover, opts)

					keymap('n', '<space>cr', vim.lsp.buf.rename, opts)
					keymap('n', '<space>ca', vim.lsp.buf.code_action, opts)

					local filetype = vim.bo[bufnr].filetype
					if disable_semantic_tokens[filetype] then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			})
		end,
	},
}
