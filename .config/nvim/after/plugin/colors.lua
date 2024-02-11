color = "rose-pine-moon"
vim.cmd.colorscheme(color)

-- Enable opacity in background, change in kitty config to apply
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
