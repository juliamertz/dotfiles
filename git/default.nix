{
  wrapPackage,
  runCommandNoCC,
  git,
  ...
}: let
  configDir = runCommandNoCC "git-config" {} ''
    mkdir -vp $out/git
    ln -svf ${./config} $out/git/config
  '';
in
  wrapPackage {
    package = git;
    extraArgs = [
      "--set XDG_CONFIG_HOME '${configDir}'"
    ];
  }
