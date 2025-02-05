{
  skhd,
  wrapPackage,
  packages,
  ...
}:
wrapPackage {
  package = skhd;
  extraFlags = "-c ${./skhdrc}";
  extraArgs = [
    "--set SCRIPTS '${packages.scripts}/bin'"
  ];
}
