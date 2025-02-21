{
  inputs,
  system,
  pkgs,
  mkImportList,
  overrideName,
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
|> overrideName "neovim"
