{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    nixvim.url = "github:nix-community/nixvim";

    # extra plugins
    noogle = {
      url = "github:juliamertz/noogle-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    godoc = {
      url = "github:juliamertz/godoc.nvim";
      flake = false;
    };
    snacks = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };

    # language servers
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      systems,
      nixvim,
      ...
    }@inputs:
    let
      forAllSystems =
        function: nixpkgs.lib.genAttrs (import systems) (system: function nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        {
          pkgs,
          lib,
          system,
          vimPlugins,
          ...
        }:
        {
          default =
            nixvim.legacyPackages.${system}.makeNixvimWithModule {
              inherit pkgs;
              module = import ./module.nix;
              extraSpecialArgs = {
                inherit inputs system vimPlugins;
              };
            }
            |> lib.setName "neovim";
        }
      );
    };
}
