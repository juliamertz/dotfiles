require("bufferline").setup{
    options = {
       offsets = {
         filetype = "NvimTree_1",
            -- text = "File Explorer",
            highlight = "Directory",
            separator = true
        }
    }
}

vim.keymap.set("n", "<M-n>", function() vim.cmd.BufferLineCycleNext() end)
vim.keymap.set("n", "<M-p>", function() vim.cmd.BufferLineCyclePrev() end)
