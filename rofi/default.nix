{
  lib,
  stdenv,
  makeWrapper,
  symlinkJoin,
  writeShellScriptBin,
  rofi-wayland,
  python3,
  pamixer,
  ...
}: let
  # assumes path contains 'launch' executable and 'theme.rasi'
  wrapWidget = path:
    stdenv.mkDerivation rec {
      name = builtins.baseNameOf path;
      src = path;

      nativeBuildInputs = [makeWrapper];
      buildInputs = [
        rofi-wayland
        python3
        pamixer
      ];

      installPhase = ''
        mkdir -p $out/bin
        install --mode +x $src/launch $out/bin/$name
        ln -sf ${./config.rasi} $out/config.rasi
      '';

      fixupPhase = ''
        wrapProgram $out/bin/$name \
          --set "THEME" "$src/theme.rasi" \
          --set "PATH" "$PATH:${lib.makeBinPath buildInputs}" \
          --chdir "$out/bin"
      '';
    };

  widgets = symlinkJoin {
    name = "rofi-widgets";
    paths = map wrapWidget [
      ./launcher
      ./audiomenu
      ./displaymenu
      ./powermenu
      ./screenshotmenu
    ];
  };
in
  writeShellScriptBin "rofi" ''
    widgets=${widgets}/bin

    if test -z $1; then
      printf "No widget name provided, choose from: "
      ls $widgets
      exit 1
    fi

    exec $widgets/$1
  ''
