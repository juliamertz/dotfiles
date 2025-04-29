{
  lib,
  decToHex,
  wrapPackage,
  jankyborders,
  ...
}: let
  toStr = val:
    if builtins.isString val
    then ''"${val}"''
    else builtins.toString val;

  colors = rec {
    hex = color: "0x" + color;
    aHex = alpha: color: hex (decToHex ((alpha / 100) * 255) + color);
  };

  makeWrapper = opts:
    wrapPackage {
      package = jankyborders;
      extraFlags =
        opts |> lib.mapAttrsToList (name: value: "${name}=${toStr value}");
    };
in
  makeWrapper {
    active_color = colors.aHex 100 "c4a7e7";
    inactive_color = colors.aHex 100 "6e6a86";
    width = 7.0;
  }
  |> lib.setName "jankyborders"
