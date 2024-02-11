return {
    -- Lazy.nvim setup
    {
        'rktjmp/lush.nvim', -- Required for rose-pine theme
        event = "VimEnter",
    },

    -- Prettier.nvim
    {
        'MunifTanjim/prettier.nvim',
        event = "BufRead",
    },

    {
        'eandrju/cellular-automaton.nvim',
        event = "BufRead",
    },

    -- Telescope.nvim
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = "Telescope",
    },

    -- Rose Pine Theme
    {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd("colorscheme rose-pine-moon")
        end,
    },

    -- Nvim-Colorizer
    {
        'NvChad/nvim-colorizer.lua',
        event = "BufRead",
    },

    -- Nvim-Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
    },

    -- Catppuccino
    {
        'catppuccin/nvim',
        as = 'catppuccin',
    },

    -- Nvim-Tree
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        cmd = "NvimTreeToggle",
    },

    -- LSP-Zero
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional
            { 'hrsh7th/nvim-cmp' },                  -- Required
            { 'hrsh7th/cmp-nvim-lsp' },              -- Required
            { 'L3MON4D3/LuaSnip' },                  -- Required
        },
    },

    -- Nvim-Comment
    {
        'terrortylor/nvim-comment',
        cmd = "CommentToggle",
    },

    -- Bufferline.nvim
    {
        'akinsho/bufferline.nvim',
        tag = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
    },

    -- Incline.nvim
    {
        'b0o/incline.nvim',
    },

    -- Lualine.nvim
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    },

    -- TailwindCSS Colorizer
    {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        config = function()
            require("tailwindcss-colorizer-cmp").setup({
                color_square_width = 2,
            })
        end,
    },

    -- Lazygit.nvim
    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}
