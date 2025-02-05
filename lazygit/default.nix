{
  wrapPackage,
  lazygit,
  delta,
  ...
}:
wrapPackage {
  package = lazygit;
  extraFlags = "--use-config-file ${./config.yml}";
  dependencies = [ delta ];
}
