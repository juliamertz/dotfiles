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
  package = w3m;
  extraFlags = "-config ${config}";
  extraArgs = [ "--set W3M_DIR '${./.}'" ];
}
