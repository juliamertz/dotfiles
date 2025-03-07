{
  pkgs,
  lib,
  writeShellScriptBin,
  symlinkJoin,
  packages,
  ...
}:
let
  inherit (builtins) elemAt readFile toString;
  splitStr = lib.strings.splitString;

  parsePackage =
    str:
    let
      parts = splitStr "=" str;
      len = lib.length parts;
    in
    if len == 1 then
      let
        path = elemAt parts 0;
        nodes = splitStr "." path;
      in
      {
        name = elemAt (nodes) ((lib.length nodes) - 1);
        path = nodes;
      }
    else if len == 2 then
      {
        name = elemAt parts 0;
        path = splitStr "." <| elemAt parts 1;
      }
    else
      throw ''
        Invalid package of length ${toString len}: "${str}"
      '';

  lookupAttrpath =
    attrs: path:
    let
      newPath = lib.drop 1 path;
      nextName = elemAt path 0;
      next = lib.getAttr nextName attrs;
    in
    if lib.length path == 1 then next else lookupAttrpath (next) newPath;

  parseRequirements =
    content:
    splitStr "\n" content
    |> map (
      line:
      let
        parts = splitStr " " line;
      in
      if (elemAt parts 0) == "#?" then parts |> lib.drop 1 |> map parsePackage else null
    )
    |> builtins.filter (value: !builtins.isNull value)
    |> lib.flatten;

  mkNamedBinPath =
    name: requirements:
    "mkdir -p $out/bin\n"
    + (
      requirements
      |> map (
        dep:
        let
          pkg = lookupAttrpath {
            inherit pkgs;
            dotfiles = packages;
          } dep.path;
        in
        "ln -sf ${lib.getExe pkg} $out/bin/${dep.name}"
      )
      |> lib.concatStringsSep "\n"
    )
    |> pkgs.runCommand "${name}-script-binpath" { };

  readScripts =
    path:
    let
      isScript = name: name != "default.nix";
      toPath = (filename: ./. + "/${filename}");
      files = builtins.readDir path;
    in
    builtins.filter isScript (builtins.attrNames files) |> map toPath;

  wrapScript =
    {
      path,
      useDash ? false,
    }:
    let
      requirements =
        parseRequirements (readFile path)
        ++ lib.optionals useDash [
          {
            name = "bash";
            path = [
              "pkgs"
              "dash"
            ];
          }
        ]
        |> mkNamedBinPath (builtins.baseNameOf path);
    in
    writeShellScriptBin (builtins.baseNameOf path) ''
      export PATH="${
        lib.makeBinPath [
          requirements
          "$PATH"
        ]
      }"
      exec ${path} "$@"
    '';
in
symlinkJoin {
  name = "scripts";
  paths = readScripts ./. |> map (path: wrapScript { inherit path; });
}
