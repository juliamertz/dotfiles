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
    git = [git];

    # languages
    nix = [
      nixd
      nix-doc
      alejandra
      nurl
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
      yaml-language-server
      helm-ls
    ];
    toml = [taplo];
    # kcl = [
    #   kcl-language-server
    # ];
    terraform = [
      terraform-ls
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
      neogit
      diffview-nvim
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
      blink-cmp
      luasnip
      # nvim-cmp
      # cmp-nvim-lsp
      # cmp-path
      # cmp_luasnip
    ];

    lua = [
      lazydev-nvim
    ];
    markdown = [
      render-markdown-nvim
    ];
    yaml = [
      vim-helm
    ];

    # base dependencies
    general = [
      lazy-nvim
      plenary-nvim
      nvim-lspconfig
      conform-nvim
      boole-nvim
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
            tsx
            python
            ocaml

            # data
            json
            xml
            toml
            yaml
            kcl
            yuck
            ron
            hcl
            helm
            proto
            prisma
            http

            # scripting
            bash
            make
            regex

            # web
            html
            css
            scss
            svelte

            markdown
            vimdoc
          ]
      ))
    ];
  };
}
