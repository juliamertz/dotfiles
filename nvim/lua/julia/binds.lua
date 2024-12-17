local utils = require 'julia.utils'
local keymap = utils.keymap

-- Pane navigation movements
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- misc
keymap('n', '<leader>cb', utils.buf_kill)

local step_size = 10
-- override pane resize step size
keymap('n', '<C-w>>', '<cmd>vertical resize -' .. step_size .. '<cr>')
keymap('n', '<C-w><', '<cmd>vertical resize +' .. step_size .. '<cr>')

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
