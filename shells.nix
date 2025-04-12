{
  pkgs,
  lib,
  inputs,
  packages,
  mkShell,
  ...
}: let
  buildForCachix = with pkgs;
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
in {
  # minimal development environment
  minimal = mkShell {
    packages = with packages; [
      neovim
      zsh
      lazygit
      tmux
      kitty
    ];
    shellHook = ''
      ${lib.getExe packages.zsh}
    '';
  };

  # shell for working in this repository
  default = mkShell {
    packages = with pkgs; [
      nurl

      treefmt
      inputs.alejandra.packages.${pkgs.system}.default
      deadnix
      taplo
      shfmt
      mdformat
      stylua

      buildForCachix
    ];
  };
}
