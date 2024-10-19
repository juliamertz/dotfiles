{ pkgs, wrapPackage, ... }:
wrapPackage {
  name = "wezterm";
  package = pkgs.wezterm;
  extraFlags = "--config-file ${./wezterm.lua}";
  extraArgs = "--set XDG_CONFIG_HOME '${../.}'";
}
