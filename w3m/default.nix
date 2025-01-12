{
  wrapPackage,
  callPackage,
  w3m,
  ...
}:
let
  config = callPackage ./config.nix { };
in
wrapPackage {
  name = "w3m";
  package = w3m;
  extraFlags = "-config ${config}";
  # extraArgs = [ "--set W3M_DIR '${./.}'" ];
}
