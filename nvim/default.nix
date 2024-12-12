{
  ripgrep,
  stdenv,
  neovim,
  gnumake,
  wrapPackage,
  ...
}:
wrapPackage {
  name = "nvim";
  package = neovim;
  dependencies = [
    stdenv.cc
    ripgrep # fast grep replacement
    gnumake # for building of some plugins
  ];
  extraFlags = "-u ${./.}/init.lua";
  extraArgs = [
    "--set XDG_CONFIG_HOME '${../.}'"
    "--argv0 'nvim'"
  ];
  postWrap = # sh
    "ln -sf $out/bin/nvim $out/bin/vim ";
}
