{
  description = "My favourite programs with their configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    simple-terminal = {
      url = "git+https://git.suckless.org/st/";
      flake = false;
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
          packages = {
            neovim = mkPackage ./nvim;
            neovim-old = mkPackage ./nvim-old;
            lazygit = mkPackage ./lazygit;
            tmux = mkPackage ./tmux;
            spotify-player = mkPackage ./spotify-player;
            wezterm = mkPackage ./wezterm;
            kitty = mkPackage ./kitty;
            alacritty = mkPackage ./alacritty;
            st = mkPackage ./st;
            rofi = mkPackage ./rofi;
            zsh = mkPackage ./zsh;
            nushell = mkPackage ./nushell;
            fishies = pkgs.callPackage ./scripts/fishies.nix { };
          };

          devShells.default = pkgs.mkShell {
            packages = with packages; [
              neovim
              lazygit
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
