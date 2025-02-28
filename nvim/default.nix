{
  pkgs,
  lib,
  system,
  inputs,
  vimPlugins,
  ...
}:
inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;
  module = import ./module.nix;
  extraSpecialArgs = {
    inherit inputs system vimPlugins;
  };
}
|> lib.setName "neovim"
