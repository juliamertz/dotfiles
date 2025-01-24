{
  readNixFiles,
  symlinkJoin,
  callPackage,
  ...
}:
let
  scripts = map (name: ./. + "/${name}") (readNixFiles ./.);
  packages = (map (p: callPackage p { }) scripts);
in
symlinkJoin {
  name = "scripts";
  paths = packages;
}
