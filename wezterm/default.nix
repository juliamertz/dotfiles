{
  pkgs,
  wrapPackage,
  ...
}:
wrapPackage {
  package = pkgs.wezterm;
  extraFlags = "--config-file ${./wezterm.lua}";
  extraArgs = "--set XDG_CONFIG_HOME '${../.}'";
}
