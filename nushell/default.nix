{
  wrapPackage,
  nushell,
  ...
}:
wrapPackage {
  name = "nu";
  package = nushell;
  extraFlags = "--config ${./config.nu} --env-config ${./env.nu}";
  # dependencies = [ delta ];
}
