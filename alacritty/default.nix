{ pkgs, wrapPackage, ... }:
wrapPackage {
  package = pkgs.alacritty;
  extraFlags = "--config-file ${./alacritty.toml}";
}
