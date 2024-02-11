require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    side = "right",
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false
  },
})

local api = require "nvim-tree.api"

vim.keymap.set("n", "<C-b>", vim.cmd.NvimTreeToggle) 
