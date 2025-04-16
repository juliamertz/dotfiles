{
  wrapPackage,
  fetchzip,
  aerospace,
  ...
}: let
  package = aerospace.overrideAttrs rec {
    version = "0.18.2-Beta";
    src = fetchzip {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
      sha256 = "sha256-/Fc4Zk8KvAdaKXyHmeL9nh79CAQLx/Y6URFWIOL5YyQ=";
    };
  };
in
  wrapPackage {
    inherit package;
    wrapPaths = ["/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"];
    extraFlags = "--config-path ${./config.toml}";
  }
