-- Patch some annoying behaviours

-- Disable semantic lsp highlighting (which breaks treesitter highlights)
for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
	vim.api.nvim_set_hl(0, group, {})
end

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('highlight_yank', {}),
	desc = 'Hightlight selection on yank',
	pattern = '*',
	callback = function()
		vim.highlight.on_yank { higroup = 'IncSearch', timeout = 500 }
	end,
})

-- Rebind ctrl-] to gd for manpages
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'man',
	callback = function()
		vim.keymap.set('n', 'gd', '<C-]>', { buffer = true })
	end,
})

-- I often type too fast...
vim.cmd 'cnoreabbrev W w'
vim.cmd 'cnoreabbrev Wa wa'
vim.cmd 'cnoreabbrev Wq wq'
vim.cmd 'cnoreabbrev Wqa wqa'
vim.cmd 'cnoreabbrev Q q'
vim.cmd 'cnoreabbrev Qa qa'
