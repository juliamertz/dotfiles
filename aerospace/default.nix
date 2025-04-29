{
  wrapPackage,
  fetchzip,
  aerospace,
  ...
}: let
  package = aerospace.overrideAttrs rec {
    version = "0.18.4-Beta";
    src = fetchzip {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
      sha256 = "sha256-TjVxq1HS/gdGi32noj7i1P6e9lXKNtBoO373Cesnwks=";
    };
  };
in
  wrapPackage {
    inherit package;
    wrapPaths = ["/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"];
    extraFlags = "--config-path ${./config.toml}";
  }
