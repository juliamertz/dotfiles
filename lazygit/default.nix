{
  wrapPackage,
  lazygit,
  difftastic,
  delta,
  ...
}:
wrapPackage {
  package = lazygit;
  extraFlags = "--use-config-file ${./config.yml}";
  dependencies = [difftastic delta];
}
