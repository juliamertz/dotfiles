{
  pkgs,
  lib,
  packages,
  stdenvNoCC,
  ...
}:
let
  path = lib.makeBinPath (with packages; [ picom ]);
  autorun = pkgs.writeShellScript "awesome-autorun" ''
    export PATH="${path}:$PATH"
    exec ${./autorun}
  '';
in
stdenvNoCC.mkDerivation {
  name = "awesome";
  src = ./.;

  unpackPhase = ''
    mkdir -p $out
    cp -r $src/plugins $src/julia $src/icons $src/*.lua $out
  '';

  installPhase = ''
    install --mode=+x ${autorun} $out/autorun
  '';
}
