{ mkScript, ... }:
mkScript "nixos-build-copy"
<|
  # sh
  ''
    der_path=$(nix build ".#nixosConfigurations.$1.config.system.build.toplevel" --print-out-paths)
    nix-copy-closure --to "$2" "$der_path"
  ''
