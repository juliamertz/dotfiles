{
  wrapPackage,
  lazygit,
  delta,
  ...
}:
wrapPackage {
  name = "lazygit";
  package = lazygit;
  extraFlags = "--use-config-file ${./config.yml}";
  dependencies = [ delta ];
}
