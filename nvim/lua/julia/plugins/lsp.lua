local utils = require 'utils'

-- LSP Keymaps and features on attach
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
	callback = function(event)
		local builtin = require 'telescope.builtin'
		local map = function(keys, func, desc)
			vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
		end

		-- Navigation
		map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
		map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
		map('gr', builtin.lsp_references, '[G]oto [R]eferences')
		map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
		map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
		map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')

		-- Actions
		map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
		map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
		map('K', vim.lsp.buf.hover, 'Hover Documentation')

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- Document highlight
		if client and client.supports_method 'textDocument/documentHighlight' then
			local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
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

		-- Inlay hints toggle
		if client and client.supports_method 'textDocument/inlayHint' then
			map('<leader>th', function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
			end, '[T]oggle Inlay [H]ints')
		end
	end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
	capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
end

local function setup_lsp(name, config)
	config = config or {}
	config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

-- Nix
if utils.enableForCat 'nix' then
	if utils.isNixCats then
		setup_lsp('nixd', {
			cmd = { 'nixd' },
			filetypes = { 'nix' },
			root_markers = { 'flake.nix', '.git' },
		})
	else
		setup_lsp('nil_ls', {
			cmd = { 'nil' },
			filetypes = { 'nix' },
			root_markers = { 'flake.nix', '.git' },
		})
	end
end

-- Bash/Shell
if utils.enableForCat 'shell' then
	setup_lsp('bashls', {
		cmd = { 'bash-language-server', 'start' },
		filetypes = { 'sh', 'bash', 'zsh' },
		root_markers = { '.git' },
		settings = {
			bash = {
				shellcheck = { enable = true },
			},
		},
	})

	-- Fix filetype detection for nix-shell shebang scripts
	vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
		pattern = '*',
		callback = function()
			local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ''
			if first_line:match '^#!.*nix%-shell' then
				vim.bo.filetype = 'sh'
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
	})
end

-- Zig
if utils.enableForCat 'zig' then
	setup_lsp('zls', {
		cmd = { 'zls' },
		filetypes = { 'zig', 'zir' },
		root_markers = { 'build.zig', 'build.zig.zon', '.git' },
	})
end

-- Python
if utils.enableForCat 'python' then
	setup_lsp('basedpyright', {
		cmd = { 'basedpyright-langserver', '--stdio' },
		filetypes = { 'python' },
		root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
	})
end

-- Go
if utils.enableForCat 'go' then
	setup_lsp('gopls', {
		cmd = { 'gopls' },
		filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
		root_markers = { 'go.work', 'go.mod', '.git' },
	})
end

-- JavaScript/TypeScript ecosystem
if utils.enableForCat 'javascript' then
	setup_lsp('ts_ls', {
		cmd = { 'typescript-language-server', '--stdio' },
		filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
		root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
	})

	setup_lsp('astro', {
		cmd = { 'astro-ls', '--stdio' },
		filetypes = { 'astro' },
		root_markers = { 'package.json', '.git' },
	})

	setup_lsp('svelte', {
		cmd = { 'svelteserver', '--stdio' },
		filetypes = { 'svelte' },
		root_markers = { 'package.json', '.git' },
		capabilities = {
			workspace = { didChangeWatchedFiles = false },
		},
	})

	setup_lsp('tailwindcss', {
		cmd = { 'tailwindcss-language-server', '--stdio' },
		filetypes = {
			'astro',
			'html',
			'css',
			'javascript',
			'javascriptreact',
			'typescript',
			'typescriptreact',
			'svelte',
			'vue',
		},
		root_markers = { 'tailwind.config.js', 'tailwind.config.ts', 'package.json', '.git' },
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
	})
end

-- Lua
if utils.enableForCat 'lua' then
	setup_lsp('lua_ls', {
		cmd = { 'lua-language-server' },
		filetypes = { 'lua' },
		root_markers = { '.luarc.json', '.luarc.jsonc', '.stylua.toml', 'stylua.toml', '.git' },
		settings = {
			Lua = {
				completion = { callSnippet = 'Replace' },
				diagnostics = {
					globals = { 'nixCats', 'vim' },
					disable = { 'missing-fields' },
				},
				telemetry = { enable = false },
				workspace = { checkThirdParty = false },
			},
		},
	})
end

if not utils.isNixCats then
	return {
		{
			'williamboman/mason.nvim',
			config = true,
		},
		{
			'williamboman/mason-lspconfig.nvim',
			dependencies = { 'williamboman/mason.nvim' },
			opts = {
				ensure_installed = {
					'bashls',
					'lua_ls',
					'ts_ls',
					'tailwindcss',
				},
				automatic_installation = true,
			},
		},
		{
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			dependencies = { 'williamboman/mason.nvim' },
			opts = {
				ensure_installed = { 'stylua' },
			},
		},
	}
end

return {
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
}
