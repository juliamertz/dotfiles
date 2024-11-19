{ pkgs, wrapPackage, ... }:
wrapPackage {
  name = "alacritty";
  package = pkgs.alacritty;
  extraFlags = "--config-file ${./alacritty.toml}";
}
