{pkgs, ...}: let
  alejandra-4 = let
    revision = "4fd58849a1b5154dca2a0334c4d3bfd2770e0359";
    nixpkgs-master = import (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${revision}.tar.gz";
      sha256 = "sha256:14qhxnga37cndxyc178pk2s13isg0fz98ai9bm03i2k5fdz5v08r";
    }) {inherit (pkgs) system;};
  in
    nixpkgs-master.alejandra;
in {
  projectRootFile = "flake.nix";

  programs = {
    taplo.enable = true;
    shfmt.enable = true;

    alejandra = {
      enable = true;
      package = alejandra-4;
    };

    stylua = {
      enable = true;
      settings = {
        quote_style = "AutoPreferSingle";
        call_parentheses = "None";
      };
    };
  };
}
