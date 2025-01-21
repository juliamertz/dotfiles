{ writeShellScriptBin, ... }:
writeShellScriptBin "dev" ''
  profile=''${1:-"default"}

  find_first() { find ./ -maxdepth 2 -type f -iname $1 | tail -n 1 }

  shell=$(find_first shell.nix)
  if [[ -f "$shell" ]]; then
    nix-shell $shell#$profile --run $SHELL
    exit
  fi

  flake=$(find_first flake.nix)
  if [[ -f "$flake" ]]; then
    nix develop $(dirname $flake)#$profile -c $SHELL 
    exit
  fi
''
