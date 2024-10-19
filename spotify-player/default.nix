{
  pkgs,
  lib,
  stdenv,
  wrapPackage,
  inputs,
  ...
}:
let
  package = inputs.spotify-player.packages.${pkgs.system}.default;
  overlay = package.overrideAttrs (_: {
    buildNoDefaultFeatures = true;
    cargoBuildFeatures =
      [
        "image"
        "fzf"
        "streaming"
        "media-control"
      ]
      ++ lib.optionals stdenv.isLinux [
        "alsa-backend"
        "daemon"
      ];
  });

in
wrapPackage {
  package = overlay;
  name = "spotify_player";
  extraFlags = "--config-folder ${./.}";
  postWrap = # sh
    ''
      ln -sf $out/bin/spotify_player $out/bin/spt
    '';
}
