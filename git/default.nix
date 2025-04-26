{
  lib,
  stdenv,
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
      <| lib.concatStringsSep "\n" (
        lib.optionals stdenv.isDarwin [(builtins.readFile "${package}/etc/gitconfig")]
        ++ [
          (builtins.readFile configPath)
          extraConfig
        ]
      );
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
