{
  lib,
  callPackage,
  wrapPackage,
  git,
  #
  signingKey ? null,
  use1Password ? false,
  ...
}: let
  builder = callPackage ./builder.nix {inherit wrapPackage;};
in
  builder.makeGit {
    package = git;
    configPath = ./.gitconfig;

    extraConfig = lib.optionalAttrs (signingKey != null) {
      user = {inherit signingKey;};
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
        ssh = lib.optionalAttrs use1Password {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
      };
    };
  }
