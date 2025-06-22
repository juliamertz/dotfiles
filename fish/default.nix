{
  pkgs,
  lib,
  stdenv,
  callPackage,
  packages,
  wrapPackage,
  ...
}: let
  pins = callPackage ./pins.nix {};

  deps = [
    packages.starship
    pkgs.atuin
    pkgs.zoxide
    pkgs.uutils-coreutils-noprefix
    pkgs.eza
    pkgs.dust
    pkgs.bat
  ];

  config = stdenv.mkDerivation {
    name = "fish-config";
    src = ./.;
    installPhase = ''
      mkdir -p $out
      cp $src/config.fish $out
    '';
  };

  themes = stdenv.mkDerivation {
    name = "fish-themes";
    src = pins.sources.rose-pine;
    installPhase = ''
      mkdir -p $out/
      cp $src/themes/* $out
    '';
  };
in
  wrapPackage {
    package = pkgs.fish;
    extraFlags = ["-N -C 'source ${config}/config.fish'"];
    extraArgs = [
      # "--set XDG_CONFIG_HOME ${config}"
      "--set FISH_THEMES_DIR ${themes}"
      "--prefix-each PATH : ${lib.makeBinPath deps}"
    ];
  }
