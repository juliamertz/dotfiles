{
  vimPlugins,
  inputs,
  system,
  pkgs,
  ...
}:
let
  nixvim = inputs.nixvim.legacyPackages.${system};
  nixvimModule = {
    inherit pkgs;
    module = import ./config.nix;
    extraSpecialArgs = { inherit vimPlugins; };
  };
in
nixvim.makeNixvimWithModule nixvimModule
