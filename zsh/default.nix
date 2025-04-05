{
  packages,
  pkgs,
  lib,
  callPackage,
  wrapPackage,
  linkFarm,
  symlinkJoin,
  ...
}:
let
  pins = callPackage ./pins.nix { };

  joinDeps =
    paths:
    symlinkJoin {
      name = "zsh-runtime-dependencies";
      paths = paths;
    };
  pluginLinkFarm =
    pkgs:
    map (pkg: {
      name = "${pkg.repo}";
      path = pkg;
    }) pkgs
    |> linkFarm "zsh-plugins";

  config = pkgs.callPackage ./config.nix { };
  pluginPackages = lib.mapAttrsToList (_: val: val) pins.sources;
  runtimeDeps = [
    packages.bat
    pkgs.bat-extras.batman
    pkgs.atuin
    pkgs.starship
    pkgs.jq
    pkgs.fzf
    pkgs.zoxide
  ];
in
wrapPackage {
  package = pkgs.zsh;
  extraArgs = [
    "--set ZDOTDIR '${config}'"
    "--set ZRUNTIMEDEPS '${joinDeps runtimeDeps}/bin'"
    "--set ZPLUGINDIR '${pluginLinkFarm pluginPackages}'"
    "--set ATUIN_CONFIG_DIR '${../atuin}'"
    "--set SCRIPTS_DIR '${packages.scripts}/bin'"
    "--set STARSHIP_CONFIG '${../starship/prompt.toml}'"
  ];
}
