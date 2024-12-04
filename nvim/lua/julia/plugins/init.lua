return {
  {
    "eandrju/cellular-automaton.nvim",
    event = "BufRead",
  },

  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function ()
      require("oil").setup({})
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>ef', ':Oil<CR>', opts)
    end
  },

  -- Colorbuddy
  -- Theme creation helper
  {
    "tjdevries/colorbuddy.nvim",
  },

  --- Color highlighter and picker
  {
    "uga-rosa/ccc.nvim",
    config = function()
      local ccc = require("ccc")
      -- local mapping = ccc.mapping

      ccc.setup({
        -- Your preferred settings
        -- Example: enable highlighter
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })

      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>cc', ':CccConvert<CR>', opts)
      vim.keymap.set('n', '<leader>cp', ':CccPick<CR>', opts)
    end
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
    lazy = false,
    config = function()
      require("Comment").setup()
    end,
  },

  {
    'fedepujol/move.nvim',
    event = "VeryLazy",
    config = function()
      require('move').setup({
        line = {
          enable = true,
          indent = true,
        },
        block = { enable = true },
        word = { enable = false },
        char = { enable = false },
      })

      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
      vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
      vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
      vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
    end,
  },

  -- -- Indent blankline
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   event = "VeryLazy",
  --   main = "ibl",
  --   opts = {},
  -- },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false,   -- This plugin is already lazy
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  },

  {
    'vyfor/cord.nvim',
    enable = true,
    build = './build || .\\build',
    event = 'VeryLazy',
    opts = {}, -- calls require('cord').setup()
  },
}
