{
  ghostty,
  callPackage,
  wrapPackage,
  ...
}:
wrapPackage {
  package = ghostty;
  extraFlags = "--config-file=${callPackage ./config.nix {}}";
}
