{
  pkgs,
  settings,
  categories,
  extra,
  name,
  mkNvimPlugin,
  ...
} @ packageDef: {
  lspsAndRuntimeDeps = with pkgs; {
    general = [
      universal-ctags
      ripgrep
      fd
      stdenv.cc.cc
    ];
    folke = [imagemagick];

    # languages
    nix = [
      nixd
      nix-doc
      alejandra
    ];
    go = [
      gopls
      gofumpt
      delve
    ];
    zig = [
      vscode-lldb-bin
    ];
    rust = [
      rust-analyzer
      rustfmt
    ];
    lua = [
      lua-language-server
      stylua
    ];
    python = [
      basedpyright
      black
    ];
    javascript = [
      nodePackages.typescript-language-server
      biome
      astro-language-server
      tailwindcss-language-server
      svelte-language-server
    ];
    yaml = [
      yamlfmt
    ];
    shell = [
      bash-language-server
      shellcheck
    ];
  };

  # This is for plugins that will load at startup without using packadd:
  startupPlugins = with pkgs.vimPlugins; {
    theme = [rose-pine];
    clipboard = [yanky-nvim];
    oil = [oil-nvim];
    filetree = [nvim-tree-lua];
    undotree = [undotree];
    harpoon = [harpoon2];
    colors = [ccc-nvim];
    mini = [
      mini-icons
      mini-comment
      mini-surround
      mini-statusline
    ];
    fuzzyfinder = [
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
    ];
    git = [
      vim-fugitive
      gitsigns-nvim
    ];
    docs = [
      godoc-nvim
      noogle-nvim
    ];
    folke = [
      trouble-nvim
      snacks-nvim
      todo-comments-nvim
    ];
    completion = [
      # blink-cmp
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      luasnip
      cmp_luasnip
    ];

    lua = [
      lazydev-nvim
    ];
    rust = [
      rustaceanvim
    ];
    markdown = [
      render-markdown-nvim
    ];

    # base dependencies
    general = [
      lazy-nvim
      plenary-nvim
      nvim-lspconfig
      conform-nvim
    ];

    debug = [
      nvim-dap
      nvim-dap-ui
      nvim-dap-go
      nvim-nio
    ];

    treesitter = [
      (nvim-treesitter.withPlugins (
        plugins:
          with plugins; [
            # programming languages
            lua
            nix
            zig
            rust
            go
            javascript
            typescript
            python

            # config formats
            json
            xml
            toml
            yaml
            yuck
            ron

            # scripting
            bash
            make
            regex

            # web
            html
            css
            scss

            markdown
            vimdoc
          ]
      ))
    ];
  };
}
