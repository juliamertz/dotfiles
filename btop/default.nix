{
  btop,
  wrapPackage,
  ...
}:
wrapPackage {
  package = btop.overrideAttrs {
    cudaSupport = true;
    rocmSupport = true;
  };
  extraArgs = [
    "--set XDG_CONFIG_HOME ${../.}"
  ];
}
