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
    { self, ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        let
          inherit (pkgs) callPackage;
          inherit (config) packages;

          mkPackage =
            path:
            callPackage path {
              inherit inputs;
              wrapPackage = callPackage ./wrapPackage.nix { };
            };
        in
        {
          packages = lib.mapAttrs (_: p: mkPackage p) {
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
            nushell = ./nushell;
            fishies = ./fishies;
          };

          devShells.default = pkgs.mkShell {
            packages = with packages; [
              neovim
              kitty
              tmux
              zsh
            ];
            shellHook = ''
              ${lib.getExe packages.zsh}
            '';
          };
        };
    };
}
