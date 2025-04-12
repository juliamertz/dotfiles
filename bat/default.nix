{
  lib,
  wrapPackage,
  runCommandNoCC,
  bat,
  ...
}: let
  cache = runCommandNoCC "bat-cache" {} ''
    export BAT_CACHE_PATH="$out"
    export BAT_CONFIG_PATH="${./.}"
    ${lib.getExe bat} cache --build
  '';
in
  wrapPackage {
    package = bat;
    extraArgs = [
      "--set BAT_CACHE_PATH ${cache}"
      "--set BAT_CONFIG_PATH ${./.}"
    ];
  }
