{
  lib,
  wrapPackage,
  writeText,
  git,
  #
  signingKey ? null,
  use1Password ? false,
  ...
}: let
  makeGitconfig = {
    package ? git,
    configPath,
    extraConfig ? "",
  }: let
    gitConfig =
      writeText ".gitconfig"
      <| lib.concatStringsSep "\n" [
        (builtins.readFile configPath)
        (builtins.readFile "${package}/etc/gitconfig")
        extraConfig
      ];
  in
    wrapPackage {
      inherit package;
      extraFlags = ["-c 'include.path=${gitConfig}'"];
    };

  configPath = ./.gitconfig;
in
  makeGitconfig {
    inherit configPath;
    extraConfig =
      {
        user = {inherit signingKey;};
        commit.gpgsign = true;
        gpg = {
          format = "ssh";
          ssh = lib.optionalAttrs use1Password {
            program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          };
        };
      }
      |> lib.optionalAttrs (builtins.isString signingKey)
      |> lib.generators.toGitINI;
  }
