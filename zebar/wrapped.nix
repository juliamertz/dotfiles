{ system, ... }:
let
  # pin all dependencies so we don't have to rebuild when flake inputs are updated
  pkgs =
    import
      (builtins.fetchTarball {
        name = "nixpkgs-zebar";
        url = "https://github.com/nixos/nixpkgs/archive/8bb37161a0488b89830168b81c48aed11569cb93.tar.gz";
        sha256 = "sha256:03p2nvghih37xm5v8v5wlcsilpx0xdi21v7iyfrvlm80h77x5xpv";
      })
      {
        inherit system;
        overlays = [
          (import <| builtins.getFlake "github:oxalica/rust-overlay/74a3fb71b0cc67376ab9e7c31abcd68c813fc226")
        ];
      };
in
pkgs.callPackage ./package.nix { }
