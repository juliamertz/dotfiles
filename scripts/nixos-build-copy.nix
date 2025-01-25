{ mkScript, ... }:
mkScript "nixos-build-copy"
<|
  # sh
  ''
    profile=$1
    to=$2

    der_path=$(nix build ".#nixosConfigurations.$profile.config.system.build.toplevel" --print-out-paths)
    nix store sign --key-file ~/keys/nix-cache/private "$der_path"
    nix store verify --trusted-public-keys "$(cat ~/keys/nix-cache/public)" "$der_path"
    nix-copy-closure --to "$to" "$der_path"
  ''
