{
  description = "My favourite programs with their configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    devshell.url = "github:numtide/devshell";

    spotify-player.url = "github:juliamertz/spotify-player/dev?dir=nix";
  };

  outputs =
    {
      self,
      devshell,
      nixpkgs,
      ...
    }@inputs:
    let
      allSystems = linuxSystems ++ darwinSystems;
      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      darwinSystems = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        s: f:
        nixpkgs.lib.genAttrs s (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ devshell.overlays.default ];
            };
          }
        );
    in
    rec {
      packages = perSystem allSystems (
        { pkgs }:
        let
          mkPackage =
            path:
            pkgs.callPackage path {
              inherit inputs;
              inherit (pkgs.callPackage ./helpers.nix { }) wrapPackage combineDerivations;
            };
        in
        pkgs.lib.mapAttrs (_: p: mkPackage p) {
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
        }
      );

      devShells = perSystem linuxSystems (
        { pkgs }:
        let
          inherit (pkgs) lib system;
        in
        {
          # shell for working in this repository
          default = pkgs.mkShell {
            packages = with pkgs; [
              pkgs.nurl
              (writeShellScriptBin "format" ''
                ${lib.getExe nixfmt-rfc-style} ./**/*.nix
                ${lib.getExe shfmt} -w .
                ${lib.getExe taplo} format ./**/*.toml
                ${lib.getExe stylua} . \
                    --call-parentheses None \
                    --quote-style AutoPreferSingle
              '')
              (writeShellScriptBin "build-devshell" ''
                nix bundle --bundler github:DavHau/nix-portable \
                  -o devshell \
                  .#devShells.${system}.minimal
              '')
            ];
            shellHook = ''
              ${lib.getExe packages.${system}.zsh}
            '';
          };

          # numtide shells that can be bundled with https://github.com/DavHau/nix-portable
          minimal = pkgs.devshell.mkShell {
            packages = with packages.${system}; [
              neovim
              zsh
              lazygit
              tmux
              kitty
            ];
            devshell.startup.interactive.text = # sh
              ''
                # skip default numtide shell
                ${pkgs.lib.getExe packages.${system}.zsh}
                exit 0
              '';
          };
        }
      );
    };
}
