{
  pkgs,
  lib,
  packages,
  mkShell,
  ...
}:
let
  shellHook = ''
    ${lib.getExe packages.zsh}
  '';
in
{
  # minimal development environment
  minimal = mkShell {
    packages = with packages; [
      neovim
      zsh
      lazygit
      tmux
      kitty
    ];
  };

  # shell for working in this repository
  default = mkShell {
    inherit shellHook;
    packages =
      with pkgs;
      let
        format = writeShellScriptBin "format" ''
          ${lib.getExe nixfmt-rfc-style} ./**/*.nix
          ${lib.getExe shfmt} -w .
          ${lib.getExe taplo} format ./**/*.toml
          ${lib.getExe stylua} . \
              --call-parentheses None \
              --quote-style AutoPreferSingle
        '';
      in
      [
        nurl
        format
      ];
  };

}
