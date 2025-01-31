{ mkScript, ... }:
mkScript "dev"
<|
  # sh
  ''
    find_first() {                                      
      find ./ -maxdepth 2 -type f -iname "$1" | tail -n 1
    }

    shell=$(find_first shell.nix)
    if test -f "$shell"; then
      nix-shell "$shell" --run "$SHELL"
      exit 0
    fi

    profile=''${1:-"default"}
    flake=$(find_first flake.nix)
    if test -f "$flake"; then
      nix develop "$(dirname "$flake")#$profile" -c "$SHELL"
    fi
  ''
