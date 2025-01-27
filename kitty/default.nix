{
  writeText,
  fetchFromGitHub,
  runCommandNoCC,
  wrapPackage,

  kitty,
  imagemagick,
  ...
}:
let
  theme = fetchFromGitHub {
    owner = "rose-pine";
    repo = "kitty";
    rev = "788bf1bf1a688dff9bbacbd9e516d83ac7dbd216";
    hash = "sha256-AcMVkliLGuabZVGkfQPLhfspkaTZxPG5GyuJdzA4uSg=";
  };

  kittyConf = writeText "kitty.conf" (
    (builtins.readFile ./kitty.conf) + "include ${theme}/dist/rose-pine-moon.conf"
  );

  configDir =
    runCommandNoCC "kitty-config-directory"
      {
        nativeBuildInputs = [ imagemagick ];
      }
      ''
        mkdir $out
        cp ${kittyConf} $out/kitty.conf
        cp ${theme}/icons/kitty.*.png $out

        # resize app icon for x11 
        magick ${theme}/icons/kitty.app.png -resize 128x128 $out/kitty.app-128.png
      '';
in
wrapPackage {
  name = "kitty";
  package = kitty;
  extraArgs = [
    "--set KITTY_CONFIG_DIRECTORY '${configDir}'"
  ];
}
