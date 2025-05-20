{
  lib,
  stdenv,
  wrapPackage,
  writeText,
  git,
  ...
}: {
  makeGit = {
    package ? git,
    configPath,
    extraConfig ? "",
  }: let
    gitConfig =
      writeText ".gitconfig"
      <| lib.concatStringsSep "\n" (
        lib.optionals stdenv.isDarwin [(builtins.readFile "${package}/etc/gitconfig")]
        ++ [
          (builtins.readFile configPath)
          (lib.generators.toGitINI extraConfig)
        ]
      );
  in
    wrapPackage {
      inherit package;
      extraFlags = ["-c 'include.path=${gitConfig}'"];
    };
}
