local utils = require 'julia.utils'
local keymap = utils.keymap

-- override pane resize step size
keymap('n', '<C-<>', '<cmd>vertical resize -10<cr>')
keymap('n', '<C->>', '<cmd>vertical resize +10<cr>')

-- Pane navigation movements
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- Miscelanious
keymap('n', '<leader>cb', utils.buf_kill)
