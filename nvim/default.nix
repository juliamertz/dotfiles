{
  ripgrep,
  stdenv,
  neovim,
  wrapPackage,
  vimPlugins,
  linkFarmFromDrvs,
  ...
}:
let
  plugins =
    linkFarmFromDrvs "neovim-plugins"
    <| (with vimPlugins; [
      rose-pine
      harpoon2
      telescope-nvim
      conform-nvim
      snacks-nvim
      trouble-nvim
      lazydev-nvim
      nvim-tree-lua
      oil-nvim
      noice-nvim
      nui-nvim
      ccc-nvim
      plenary-nvim
      render-markdown-nvim
      todo-comments-nvim
      mini-statusline
      mini-surround
      mini-git
      mini-icons
      nvim-treesitter
    ]);

  parsers =
    linkFarmFromDrvs "treesitter-parsers"
    <| (with vimPlugins.nvim-treesitter.builtGrammars; [
      zig
      rust
      scss
      json
      yaml
      sql
      go
      vim
      vimdoc
      lua
      javascript
      nix
    ]);

in
wrapPackage {
  name = "nvim";
  package = neovim;
  dependencies = [
    ripgrep
    stdenv.cc
  ];
  extraFlags = "-u ${./.}/init.lua";
  extraArgs = [
    "--set XDG_CONFIG_HOME '${../.}'"
    "--set NVIM_PLUGINPATH '${plugins}'"
    "--set NVIM_PARSERPATH '${parsers}'"
    "--argv0 'nvim'"
  ];
  postWrap = # sh
    "ln -sf $out/bin/nvim $out/bin/vim ";
}
