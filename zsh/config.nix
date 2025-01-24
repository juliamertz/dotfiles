{
  runCommand,
  uutils-coreutils-noprefix,
  stdenv,
  writeText,
  enableUutils ? true, # TODO:
}:
let
  optionalString = condition: content: if condition then content else "";
  uutils-patch = # sh
    ''
      export PATH=${uutils-coreutils-noprefix}/bin:$PATH
    '';
  extraConfig = ''
    ${optionalString enableUutils uutils-patch}
  '';

  rc = writeText ".zshrc" ((builtins.readFile ./.zshrc) + extraConfig);
in
stdenv.mkDerivation {
  name = "zsh-config";
  src = ./.;
  buildPhase = ''
    mkdir -p $out
    cp ${rc} $out/.zshrc
    cp ${./prompt.zsh} $out/prompt.zsh
    cp ${./tools.zsh} $out/tools.zsh
  '';
}
# ++ lib.optionals enableUutils [ pkgs.uutils-coreutils ];
# runCommand "zsh-config"
#   {
#   }
#   ''
#     TEMP=$(mktemp -d)
#     cp --no-preserve=mode ${./.}/*.zsh ${./.}/.zshrc $TEMP
#     echo "source ${extraConfig}" >> $TEMP/.zshrc
#     cp -r $TEMP $out
#   ''
