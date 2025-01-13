{
  ripgrep,
  stdenv,
  neovim,
  wrapPackage,
  vimPlugins,
  linkFarm,
  ...
}:
let
  mapPlugins =
    p:
    map (v: {
      name = v.pname;
      path = v;
    }) p;

  plugins =
    with vimPlugins;
    [
      rose-pine
      nvim-tree-lua
      harpoon2
      telescope-nvim
      conform-nvim
      snacks-nvim
      todo-comments-nvim
      trouble-nvim
      plenary-nvim
      lazydev-nvim
      oil-nvim
      render-markdown-nvim
      noice-nvim
    ]
    |> mapPlugins
    |> linkFarm "neovim-plugins";
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
    "--set NVIM_PLUGIN_DIR '${plugins}'"
    "--set LAZYPATH '${vimPlugins.lazy-nvim}'"
    "--argv0 'nvim'"
  ];
  postWrap = # sh
    "ln -sf $out/bin/nvim $out/bin/vim ";
}
