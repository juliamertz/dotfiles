{
  inputs,
  system,
  wrapPackage,
  callPackage,
  ...
}:
let
  lib = callPackage ./lib.nix { };
  config = lib.mkConfig ./widgets {
    startupConfigs = [
      {
        path = "bar/bar.zebar.json";
        preset = "default";
      }
    ];
  };
in
wrapPackage {
  package = inputs.zebar.packages.${system}.default;
  extraArgs = [
    "--set ZEBAR_CONFIG '${config}'"
  ];
}
