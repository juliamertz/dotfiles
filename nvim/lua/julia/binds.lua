local utils = require 'julia.utils'
local keymap = utils.keymap

-- Pane navigation movements
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- misc
keymap('n', '<leader>cb', utils.buf_kill)
keymap('t', '<esc><esc>', '<c-\\><c-n>')

local function vresize(step)
	vim.cmd('vertical resize ' .. step)
end

keymap('n', '<C-w>>', function()
	vresize('-' .. vim.o.columns / 10)
end)

keymap('n', '<C-w><', function()
	vresize('+' .. vim.o.columns / 10)
end)

-- Rebind ctrl-] to gd for man/help pages
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'man', 'help' },
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
