{ pkgs }:
let
  inherit (pkgs) runCommandNoCC rofi;
in
runCommandNoCC "dm-scripts" { buildInputs = [ rofi ]; } ''
  mkdir -p $out/bin
  cp -r ${./launcher/launcher.sh} $out/bin/dm-launcher
  cp -r ${./powermenu/powermenu.sh} $out/bin/dm-powermenu
''
