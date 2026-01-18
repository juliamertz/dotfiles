{
  pkgs,
  lib,
  stdenv,
  wrapPackage,
  inputs,
  ...
}: let
  package = inputs.spotify-player.packages.${pkgs.stdenv.hostPlatform.system}.default;
  overlay = package.overrideAttrs (_: {
    buildNoDefaultFeatures = true;
    meta.mainProgram = "spotify_player";
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
    name = "spotify-player";
    package = overlay;
    extraFlags = "--config-folder ${./.}";
    postWrap =
      # sh
      ''
        ln -sf $out/bin/spotify_player $out/bin/spt
      '';
  }
