{
  wrapPackage,
  fetchzip,
  aerospace,
  ...
}:
wrapPackage {
  package = aerospace;
  wrapPaths = ["/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"];
  extraFlags = "--config-path ${./config.toml}";
}
