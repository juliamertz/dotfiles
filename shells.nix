{
  pkgs,
  lib,
  packages,
  mkShell,
  ...
}:
let
  formatAll =
    with pkgs;
    writeShellScriptBin "format" ''
      echo Formatting nix files
      ${lib.getExe nixfmt-rfc-style} ./**/*.nix
      ${lib.getExe nodePackages.prettier} -w **/*.md
      ${lib.getExe shfmt} -w .
      ${lib.getExe taplo} format ./**/*.toml
      ${lib.getExe stylua} . --call-parentheses None --quote-style AutoPreferSingle
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
    shellHook = ''
      ${lib.getExe packages.zsh}
    '';

    packages = [
      pkgs.nurl
      formatAll
    ];
  };
}
