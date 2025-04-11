{
  sketchybar,
  pkgs,
  wrapPackage,
  symlinkJoin,
  ...
}: let
  deps = symlinkJoin {
    name = "sketchybar-dependencies";
    paths = with pkgs; [
      sketchybar
      yabai
      jq
    ];
  };
in
  wrapPackage {
    package = sketchybar;
    appendFlags = "--config ${./sketchybarrc}";
    extraArgs = [
      "--set MODULES '${./modules}'"
      "--set PATH $PATH:${deps}/bin"
    ];
  }
