vim.g.mapleader = ' '

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
