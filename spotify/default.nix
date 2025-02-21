{
  system,
  inputs,
  overrideName,
  importUnfree,
  ...
}:
let
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
}
|> overrideName "spotify"
