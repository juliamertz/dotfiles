{
  lib,
  system,
  inputs,
  importUnfree,
  ...
}: let
  inherit (inputs) nixpkgs spicetify;
  pkgs = importUnfree nixpkgs;
  spicePkgs = spicetify.legacyPackages.${system};
in
  spicetify.lib.mkSpicetify pkgs {
    theme = spicePkgs.themes.ziro;
    colorScheme = "rose-pine-moon";
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplayMod
      keyboardShortcut
      fullAlbumDate
    ];
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
      newReleases
    ];
  }
  |> lib.setName "spotify"
