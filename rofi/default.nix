{ pkgs, lib, ... }:
let
  inherit (pkgs) runCommandNoCC writeShellScriptBin rofi;
  mkMenu =
    name:
    writeShellScriptBin name ''
      THEME=${./${name}/theme.rasi}; ${./${name}/launch}
    '';

  menus =
    [ "launcher" ]
    |> lib.mapListToAttrs (l: {
      key = l;
      value = mkMenu l;
    });
in
runCommandNoCC "dm-scripts" { buildInputs = [ rofi ]; } ''
  mkdir -p $out/bin
  cp -r ${menus.launcher}/bin/launcher $out/bin/dm-launcher
  cp -r ${./powermenu/powermenu.sh} $out/bin/dm-powermenu
''
