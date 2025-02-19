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

  buildForCachix =
    with pkgs;
    writeShellScriptBin "build-for-cachix" ''
      system=$(nix eval --impure --raw --expr 'builtins.currentSystem')
      outputs=$(nix flake show --json 2> /dev/null)
      packages=$(echo "$outputs" | ${lib.getExe jq} -r ".packages[\"${system}\"] | keys | .[]")

      echo "$packages" | while read -r package; do 
        echo "Building $package"
        output_paths=$(nix build ".#''${package}" --print-out-paths)

        echo "Pushing to cache"
        ${cachix}/bin/cachix push juliamertz "$output_paths"
      done
    '';

    shellHook = ''
      ${lib.getExe packages.zsh}
    '';
in
{
  # minimal development environment
  minimal = mkShell {
    inherit shellHook;
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
    packages = [
      pkgs.nurl
      formatAll
      buildForCachix
    ];
  };
}
