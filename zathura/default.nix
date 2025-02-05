{ zathura, wrapPackage, ... }:
wrapPackage {
  package = zathura;
  extraFlags = "--config-dir ${./.}";
}
