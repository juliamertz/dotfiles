{ pkgs, wrapPackage, ... }:
wrapPackage {
  name = "zsh";
  package = pkgs.zsh;
  extraArgs = "--set ZDOTDIR '${./.}' --set EDITOR nvim";
  dependencies = with pkgs; [
    bat
    jq
    zoxide
  ];
}
