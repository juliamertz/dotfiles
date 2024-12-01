{
  description = "My favourite programs with their configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
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

          mkPackage =
            path:
            callPackage path {
              inherit inputs;
              wrapPackage = callPackage ./wrapPackage.nix { };
            };
        in
        {
          packages = {
            neovim = mkPackage ./nvim;
            lazygit = mkPackage ./lazygit;
            tmux = mkPackage ./tmux;
            spotify-player = mkPackage ./spotify-player;
            wezterm = mkPackage ./wezterm;
            kitty = mkPackage ./kitty;
            alacritty = mkPackage ./alacritty;
            rofi = mkPackage ./rofi;
            zsh = mkPackage ./zsh;
          };
        };
    };
}
