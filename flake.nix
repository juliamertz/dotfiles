{
  description = "My favourite programs with their configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    pink-lavender = {
      url = "github:juliamertz/pink-lavender";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    spotify-player.url = "github:juliamertz/spotify-player/dev?dir=nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { pkgs, lib, ... }:
        let
          inherit (pkgs) callPackage;

          wrapPackage = callPackage ./wrapPackage.nix { };
          mkPackages = attrs: lib.mapAttrs (_: x: callPackage x { inherit inputs wrapPackage; }) attrs;
        in
        {
          packages = mkPackages {
            neovim = ./nvim;
            lazygit = ./lazygit;
            tmux = ./tmux;
            spotify-player = ./spotify-player;
            wezterm = ./wezterm;
            kitty = ./kitty;
            alacritty = ./alacritty;
          };
        };
    };
}
