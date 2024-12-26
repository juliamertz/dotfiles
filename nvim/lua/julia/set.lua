vim.opt.nu = true
vim.opt.relativenumber = true

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
vim.wo.fillchars = 'eob: ' -- remove tilde from empty lines

vim.o.cmdheight = 0

vim.opt.undofile = true
vim.opt.undodir = os.getenv 'HOME' .. '/.cache/nvim_undo'
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- Disable semantic lsp highlighting (which breaks treesitter highlights)
for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
	vim.api.nvim_set_hl(0, group, {})
end

-- Highlight yanked text
-- vim.api.nvim_create_autocmd('TextYankPost', {
-- 	group = vim.api.nvim_create_augroup('highlight_yank', {}),
-- 	desc = 'Hightlight selection on yank',
-- 	pattern = '*',
-- 	callback = function()
-- 		vim.highlight.on_yank { higroup = 'IncSearch', timeout = 500 }
-- 	end,
-- })

-- Disable line numbers in embedded terminals
vim.api.nvim_create_autocmd('TermOpen', {
	group = vim.api.nvim_create_augroup('termopen', { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})
