{
  wrapPackage,
  starship,
  ...
}:
wrapPackage {
  package = starship;
  extraArgs = "--set STARSHIP_CONFIG '${./prompt.toml}'";
}
