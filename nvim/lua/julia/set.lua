local utils = require 'utils'

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.cmdheight = 0
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = 'split'
vim.opt.nu = true
vim.opt.fileignorecase = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.selection = 'exclusive'
vim.opt.swapfile = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 12
vim.opt.updatetime = 50
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.virtualedit = 'none'

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

utils.keymap('n', '<C-h>', '<C-w>h')
utils.keymap('n', '<C-j>', '<C-w>j')
utils.keymap('n', '<C-k>', '<C-w>k')
utils.keymap('n', '<C-l>', '<C-w>l')

utils.keymap('n', '<C-w>>', function()
	vim.cmd('vertical resize -' .. vim.o.columns / 10)
end)
utils.keymap('n', '<C-w><', function()
	vim.cmd('vertical resize +' .. vim.o.columns / 10)
end)

vim.cmd [[
  cnoreabbrev W w
  cnoreabbrev Wa wa
  cnoreabbrev Wq wq
  cnoreabbrev Wqa wqa
  cnoreabbrev Q q
  cnoreabbrev Qa qa
  cnoreabbrev So so
]]

-- Disable semantic lsp highlighting (which breaks treesitter highlights)
-- TODO: some languages actually benefit from this e.g. nix while languages like rust just look ugly
for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
	vim.api.nvim_set_hl(0, group, {})
end

-- Rebind ctrl-] to gd for man/help pages
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'man', 'help' },
	callback = function()
		vim.keymap.set('n', 'gd', '<C-]>', { buffer = true })
	end,
})

-- Fix commenting in KCL
vim.api.nvim_create_autocmd("FileType", {
  pattern = "kcl",
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})

-- Auto-detect helm template files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
	callback = function()
		local filepath = vim.fn.expand '%:p'
		local filename = vim.fn.expand '%:t'

		local is_helm = false

		if
			filepath:match '/templates/.*%.ya?ml$'
			or filepath:match '/templates/.*%.tpl$'
			or filepath:match '/templates/.*%.txt$'
		then
			is_helm = true
		end

		if filename:match '%.gotmpl$' then
			is_helm = true
		end

		if filename:match '^helmfile.*%.ya?ml$' then
			is_helm = true
		end

		if is_helm then
			vim.bo.filetype = 'helm'
		end
	end,
})

if utils.enableForCat 'nix' then
	vim.api.nvim_create_user_command('Nurl', 'read !nurl <args> 2>/dev/null', { nargs = '*' })
end
