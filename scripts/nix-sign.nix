{ mkScript, ... }:
mkScript "nix-sign"
<|
  # sh
  ''
    nix store sign --key-file ~/keys/nix-cache/private "$1"
    nix store verify --trusted-public-keys "$(cat ~/keys/nix-cache/public)" "$1"
  ''
