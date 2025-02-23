{
  inputs,
  system,
  wrapPackage,
  ...
}:
wrapPackage {
  package = inputs.zebar.packages.${system}.default;
  extraArgs = [
    "--set ZEBAR_CONFIG '${./widgets}'"
  ];
}
