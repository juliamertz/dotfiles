{
  pkgs,
  stdenv,
  lib,
  packages,
  wrapPackage,
  ...
}: let
  deps = [
    packages.starship
    pkgs.atuin
    pkgs.zoxide
    pkgs.uutils-coreutils-noprefix
    pkgs.eza
    pkgs.dust
    pkgs.bat
  ];
  rose-pine = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "fish";
    rev = "b82982c55582cfaf6f220de1893c7c73dd0cb301";
    hash = "sha256-Dvaw1k7XOU2NUQbTJAXPgAOPN1zTLVrc7NZDY5/KHeM=";
  };
  config = stdenv.mkDerivation {
    name = "fish-config";
    src = ./.;

    installPhase = ''
      mkdir -p $out/themes
      cp $src/config.fish $out/config.fish
      cp ${rose-pine}/themes/* $out/themes/
    '';
  };
in
  wrapPackage {
    package = pkgs.fish;
    extraArgs = "--prefix-each PATH : ${lib.makeBinPath deps}";
    extraFlags = "-N -C 'source ${config}/config.fish'";
  }
