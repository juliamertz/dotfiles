{
  description = "Programs I use wrapped with their configurations";

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
        { pkgs, ... }:
        let
          inherit (pkgs) callPackage;
          wrapPackage = callPackage ./wrapPackage.nix { };
          wrap = p: callPackage p { inherit wrapPackage inputs; };
        in
        {
          packages = {
            neovim = wrap ./nvim;
            lazygit = wrap ./lazygit;
            tmux = wrap ./tmux;
            spotify-player = wrap ./spotify-player;
            wezterm = wrap ./wezterm;
            kitty = wrap ./kitty;
          };
        };
    };
}
