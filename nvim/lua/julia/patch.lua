-- Path some annoying behaviours

-- Disable semantic lsp highlighting (which breaks treesitter highlights)
for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
	vim.api.nvim_set_hl(0, group, {})
end

-- I often type too fast...
vim.cmd 'cnoreabbrev W w'
vim.cmd 'cnoreabbrev Wa wa'
vim.cmd 'cnoreabbrev Wq wq'
vim.cmd 'cnoreabbrev Q q'
vim.cmd 'cnoreabbrev Qa qa'
