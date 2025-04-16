{
  runCommandNoCC,
  writeShellScript,
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
  aerospace-wrapped = writeShellScript "AeroSpace" ''
    exec -a "$0" "${aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" \
      --config-path ${./config.toml} "$@"
  '';
in
  runCommandNoCC "aerospace" {} ''
    mkdir -p "$out/Applications/AeroSpace.app/Contents/MacOS/"
    install --mode +x ${aerospace-wrapped} "$out/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
    cp -vr ${package}/share $out/share
    cp -vr ${package}/bin $out/bin
  ''
