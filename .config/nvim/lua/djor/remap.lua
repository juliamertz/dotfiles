local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

keymap("n", "<C-j>", "<C-w>h", opts)
keymap("n", "<C-k>", "<C-w>j", opts)
keymap("n", "<C-l>", "<C-w>k", opts)
keymap("n", "<C-;>", "<C-w>l", opts)
