local function keymap(mode, map, cmd, opts)
	vim.keymap.set(
		mode,
		map,
		cmd,
		vim.tbl_extend('force', {
			noremap = true,
			silent = true,
		}, opts or {})
	)
end

keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')


local function vresize(step)
	vim.cmd('vertical resize ' .. step)
end

keymap('n', '<C-w>>', function()
	vresize('-' .. vim.o.columns / 10)
end)
keymap('n', '<C-w><', function()
	vresize('+' .. vim.o.columns / 10)
end)

-- I often type too fast...
vim.cmd [[
  cnoreabbrev W w
  cnoreabbrev Wa wa
  cnoreabbrev Wq wq
  cnoreabbrev Wqa wqa
  cnoreabbrev Q q
  cnoreabbrev Qa qa
]]

-- Disable semantic lsp highlighting (which breaks treesitter highlights)
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

-- add detection for hyprlang
vim.filetype.add {
	pattern = {
		['.*/hypr/.*%.conf'] = 'hyprlang',
	},
}
