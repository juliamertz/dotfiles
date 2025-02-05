{
  stdenv,
  writeText,
  uutils-coreutils-noprefix,
  enableUutils ? true,
}:
let
  optionalString = condition: content: if condition then content else "";

  uutils-patch = # sh
    ''
      # prepend path to take precedence over default core utils
      export PATH=${uutils-coreutils-noprefix}/bin:$PATH
    '';

  extraConfig = # sh
    ''
      ${optionalString enableUutils uutils-patch}
    '';

  zshrc = writeText ".zshrc" <| (builtins.readFile ./.zshrc) + extraConfig;
in
stdenv.mkDerivation {
  name = "zsh-config";
  src = ./.;
  buildPhase = ''
    mkdir -p $out
    cp ${zshrc} $out/.zshrc
    cp ${./prompt.zsh} $out/prompt.zsh
    cp ${./tools.zsh} $out/tools.zsh
  '';
}
