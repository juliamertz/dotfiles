{ mkScript, ... }:
mkScript [
  "comma"
  ","
]
<|
  # sh
  ''
    nix-shell -p "$@" --run "$SHELL"
  ''
