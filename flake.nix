{
  description = "My favourite programs with their configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    spotify-player.url = "github:juliamertz/spotify-player/dev?dir=nix";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    { nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        { pkgs, lib, ... }:
        let helpers = pkgs.callPackage ./helpers.nix { inherit inputs; }; in
        rec {
          packages = lib.mapAttrs (_: p: helpers.mkProgram p) {
            neovim = ./nvim;
            lazygit = ./lazygit;
            tmux = ./tmux;
            spotify-player = ./spotify-player;
            weechat = ./weechat;
            wezterm = ./wezterm;
            kitty = ./kitty;
            alacritty = ./alacritty;
            rofi = ./rofi;
            zsh = ./zsh;
            bash = ./bash;
            w3m = ./w3m;
            eww = ./eww;
          };

          devShells = import ./shells.nix {
            inherit (pkgs) lib system mkShell;
            inherit pkgs packages;
          };
        };
    };
}
