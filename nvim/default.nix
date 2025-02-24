{
  pkgs,
  lib,
  inputs,
  system,
  mkImportList,
  ...
}:
let
  nixvim = inputs.nixvim.legacyPackages.${system};
in
nixvim.makeNixvimWithModule {
  inherit pkgs;
  module = import ./module.nix;
  extraSpecialArgs = {
    inherit (pkgs) vimPlugins;
    inherit mkImportList;
  };
}
|> lib.setName "neovim"
