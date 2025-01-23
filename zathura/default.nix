{ zathura, wrapPackage, ... }:
wrapPackage {
  name = "zathura";
  package = zathura;
  extraFlags = "--config-dir ${./.}";
}
