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
              inherit (callPackage ./helpers.nix { }) wrapPackage combineDerivations;
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
            bash = ./bash;
            nushell = ./nushell;
            fishies = ./fishies;
          };

          devShells.default =
            let
              format =
                with pkgs;
                writeShellScriptBin "format" ''
                  ${lib.getExe nixfmt-rfc-style} ./**/*.nix
                  ${lib.getExe shfmt} -w .
                  ${lib.getExe taplo} format ./**/*.toml
                  ${lib.getExe stylua} . \
                      --call-parentheses None \
                      --quote-style AutoPreferSingle
                '';
            in
            pkgs.mkShell {
              packages = [
                format
                pkgs.nurl
              ];
              shellHook = ''
                ${lib.getExe packages.zsh}
              '';
            };
        };
    };
}
