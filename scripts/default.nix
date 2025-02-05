{
  lib,
  runCommandNoCC,
  writeShellScriptBin,
  symlinkJoin,
  readNixFiles,
  callPackage,
  packages,
  ...
}:
let
  mkScript =
    names: content:
    if builtins.isList names then
      let
        name = builtins.elemAt names 0;
        script = writeShellScriptBin name content;
        aliases = builtins.filter (n: n != name) names;
        linkAlias =
          alias: # sh
          ''
            ln -vs $out/bin/${name} $out/bin/${alias}
          '';
      in
      runCommandNoCC "script-${name}" { } ''
        mkdir -p $out/bin
        cp ${script}/bin/${name} $out/bin/${name}
        ${map (a: linkAlias a) aliases |> lib.concatStringsSep "\n"}
      ''
    else
      let
        script = writeShellScriptBin names content;
      in
      runCommandNoCC "script-${names}" { } ''
        mkdir -p $out/bin
        cp ${script}/bin/${names} $out/bin/${names}
      '';

  files = readNixFiles ./.;
  localPath = filename: ./. + "/${filename}";
  scripts = map (p: callPackage (localPath p) { inherit mkScript packages; }) files;
in
symlinkJoin {
  name = "scripts";
  paths = scripts;
}
