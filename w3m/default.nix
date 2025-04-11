{
  w3m,
  lib,
  wrapPackage,
  writeText,
  ...
}: let
  config = (builtins.readFile ./w3m.conf) + "keymap_file ${keybinds}" |> writeText "w3m-config";
  keybinds =
    writeText "w3m-keybinds"
    <| lib.concatStringsSep "\n" [
      (builtins.readFile ./reset.conf)
      (builtins.readFile ./keybinds.conf)
    ];
in
  wrapPackage {
    package = w3m;
    extraFlags = "-config ${config}";
    extraArgs = ["--set W3M_DIR '${./.}'"];
  }
