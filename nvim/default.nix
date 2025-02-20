{
  inputs,
  system,
  pkgs,
  mkImportList,
  ...
}:
let
  nixvim = inputs.nixvim.legacyPackages.${system};
  module = {
    inherit pkgs;
    module = import ./module.nix;
    extraSpecialArgs = {
      inherit (pkgs) vimPlugins;
      inherit mkImportList;
    };
  };
  nixvim' = nixvim.makeNixvimWithModule module;
in
nixvim'.overrideAttrs { name = "neovim"; }
