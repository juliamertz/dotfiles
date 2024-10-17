{
  ripgrep,
  stdenv,
  neovim,
  wrapPackage,
}:
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
    "--argv0 'nvim'"
  ];
  postWrap = # sh
    "ln -sf $out/bin/nvim $out/bin/vim ";
}
