{
  wrapPackage,
  kubie,
  ...
}:
wrapPackage {
  package = kubie;
  extraFlags = "--use-config-file ${./config.yml}";
}

