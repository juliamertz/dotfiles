{
  pkgs,
  lib,
  runCommandNoCC,
  makeWrapper,
  ...
}:
let
  dependencies = lib.makeBinPath (
    with pkgs;
    [
      fzf
      urlencode
      wakeonlan
    ]
  );
in
runCommandNoCC "scripts" { nativeBuildInputs = [ makeWrapper ]; } ''
  mkdir -p $out/bin

  for file in ${./.}/*; do
    if [[ -x "$file" ]]; then
      outfile=$out/bin/$(basename $file)

      cp $file $outfile
      wrapProgram $outfile \
        --prefix PATH : "${dependencies}" \
        --set SCRIPTS "$out/bin"
    fi
  done
''
