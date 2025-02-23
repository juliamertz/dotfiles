{ pkgs, ... }:
let
  # TODO: remove this when zig 14.0 is stable
  package =
    let
      repo = "zigtools/zls";
      rev = "43bece5b7a01ef266f895603e53a063ab012156b";
    in
    (builtins.getFlake "github:${repo}/${rev}").packages.${pkgs.system}.zls;

in
{
  plugins.lsp.servers.zls = {
    enable = true;
    inherit package;
  };
}
