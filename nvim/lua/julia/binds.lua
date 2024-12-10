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

-- Yank to system clipboard
keymap('n', '<C-y>', '"+y')

-- Miscelanious
keymap('n', '<leader>cb', utils.buf_kill)
-- keymap('n', '<leader>ut', undotree.toggle)

-- local function yank_history()
--   require('telescope').extensions.yank_history.yank_history({})
-- end
-- keymap('n', '<leader>pp', yank_history)
--
-- -- Yanky
-- vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
-- vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
-- vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
-- vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
--
-- vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
-- vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
