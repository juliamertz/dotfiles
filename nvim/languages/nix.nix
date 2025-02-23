{ pkgs, ... }:
let
  # unstable build of nil_ls with support for pipe operators
  package =
    let
      repo = "oxalica/nil";
      rev = "2e24c9834e3bb5aa2a3701d3713b43a6fb106362";
    in
    (builtins.getFlake "github:${repo}/${rev}").packages.${pkgs.system}.default;
in
{
  plugins.lsp.servers.nil_ls = {
    enable = true;
    inherit package;
    settings = {
      nix = {
        flake = {
          autoArchive = true;
        };
      };
    };
  };
}
