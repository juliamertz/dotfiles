{
  pkgs,
  lib,
  inputs,
  packages,
  mkShell,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;

  pkgs-25_05 = import inputs.nixpkgs-25_05 {inherit system;};

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
      (neovim.withCats {
        folke = false;
        clipboard = false;
        docs = false;

        rust = false;
        zig = false;
        python = false;
        javascript = false;
        go = false;
      })
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
      alejandra
      deadnix
      taplo
      shfmt
      pkgs-25_05.mdformat
      stylua
      (
        let
          config =
            writeText ".yamlfmt"
            # yaml
            ''
              formatter:
                retain_line_breaks_single: true
            '';
        in
          stdenv.mkDerivation {
            name = "yamlfmt";
            src = yamlfmt;
            buildInputs = [makeWrapper];
            buildPhase = ''
              makeWrapper $src/bin/yamlfmt $out/bin/yamlfmt \
                --add-flags "-conf ${config}"
            '';
          }
      )
      buildForCachix
      inputs.nixpins.packages.${system}.default
    ];

    NIX_CONFIG = ''
      allow-import-from-derivation = true
    '';
  };
}
