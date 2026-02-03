local utils = require 'utils'

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

		if client and client.server_capabilities.inlayHintProvider then
			map('<leader>th', function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
			end, '[T]oggle Inlay [H]ints')
		end
	end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
	pattern = '*',
	callback = function()
		-- Fix filetype detection for nix-shell shebang scripts
		if vim.bo.filetype == 'nix' then
			local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ''
			if first_line:match '^#!.*nix%-shell' then
				vim.bo.filetype = 'sh'
			end
		end
	end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

local function setup_lsp(name, config)
	config.capabilities = vim.tbl_deep_extend('force', capabilities, config.capabilities or {})
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

if utils.enableForCat 'nix' then
	if utils.isNixCats then
		setup_lsp('nixd', {})
	else
		setup_lsp('nil_ls', {})
	end
end

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
end

if utils.enableForCat 'zig' then
	setup_lsp('zls', {})
end

if utils.enableForCat 'rust' then
	setup_lsp('rust_analyzer', {})
end

if utils.enableForCat 'python' then
	setup_lsp('basedpyright', {
		cmd = { 'basedpyright-langserver', '--stdio' },
		filetypes = { 'python' },
		root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
	})
end

if utils.enableForCat 'go' then
	setup_lsp('gopls', {})
end

if utils.enableForCat 'javascript' then
	setup_lsp('vtsls', {
		cmd = { 'vtsls', '--stdio' },
		filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
		root_markers = { 'package.json' },
		workspace_required = true,
		settings = {
			vtsls = {
				autoUseWorkspaceTsdk = true,
			},
		},
	})

	setup_lsp('denols', {
		cmd = { 'deno', 'lsp' },
		filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
		root_markers = { 'deno.json', 'deno.jsonc' },
		workspace_required = true,
	})

	setup_lsp('astro', {})

	setup_lsp('svelte', {})

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

return {
	'neovim/nvim-lspconfig',
	dependencies = {
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
