{
  pkgs,
  lib,
  writeShellScriptBin,
  symlinkJoin,
  runCommand,
  packages,
  ...
}:
let
  inherit (lib.strings) splitString;
  inherit (builtins)
    elemAt
    match
    filter
    isNull
    ;

  scriptPackages = pkgs // {
    dotfiles = packages;
  };

  parseNixShellShebang =
    args:
    let
      # TODO: make these regexes more forgiving
      # working format: '#! nix-shell -i bash -p pkgs.neovim
      interpreter = elemAt (match ".*-i ([a-zA-Z]+).*" args) 0;
      packages = elemAt (match ".*-p (.*)" args) 0 |> splitString " ";
    in
    {
      inherit
        interpreter
        packages
        ;
    };

  parseRequirements =
    content:
    splitString "\n" content
    |> map (
      line:
      let
        parts = splitString " " line;
      in
      if (elemAt parts 0) == "#!" && (elemAt parts 1) == "nix-shell" then
        parts |> lib.drop 2 |> lib.concatStringsSep " " |> parseNixShellShebang
      else if (elemAt parts 0) == "#?" && (elemAt parts 1) == "alias" then
        { aliases = parts |> lib.drop 1; }
      else
        null
    )
    |> filter (value: !isNull value)
    |> lib.flatten
    |> lib.mergeAttrsList;

  lookupAttrpath =
    attrs: path:
    let
      next = lib.getAttr (elemAt path 0) attrs;
    in
    if lib.length path == 1 then next else lookupAttrpath (next) (lib.drop 1 path);

  deps2binPath =
    deps:
    let
      packages = map (p: lookupAttrpath scriptPackages (lib.splitString "." p)) deps;
    in
    (lib.makeBinPath packages) + ":$PATH";

  readScripts =
    path:
    let
      isScript = name: name != "default.nix";
      toPath = (filename: ./. + "/${filename}");
      files = builtins.readDir path;
    in
    filter isScript (builtins.attrNames files) |> map toPath;

  cleanShebangs =
    content:
    let
      lines = lib.splitString "\n" content;
      isMetadata = line: builtins.match "#[!?].*" line |> isNull;
    in
    builtins.filter isMetadata lines |> lib.concatStringsSep "\n";

  mkAliasBin =
    script: alias:
    runCommand "alias" { } ''
      mkdir -p $out/bin
      ln -sf ${lib.getExe script} $out/bin/${alias}
    '';

  wrapScript =
    {
      path,
      requirements,
      useDash ? false,
    }:
    let
      binPath = if lib.hasAttr "packages" requirements then deps2binPath requirements.packages else null;
      patched = pkgs.writeScript "${builtins.baseNameOf path}-patched" ''
        #!${lib.getExe pkgs.${requirements.interpreter or "bash"}}
        ${cleanShebangs (builtins.readFile path)}
      '';
    in
    writeShellScriptBin (builtins.baseNameOf path) ''
      ${lib.optionalString (!isNull binPath) ''export PATH="${binPath}"''}
      exec ${patched} "$@"
    '';
in
symlinkJoin {
  name = "scripts";
  paths =
    readScripts ./.
    |> map (
      path:
      let
        requirements = parseRequirements (builtins.readFile path);
        wrapped = wrapScript { inherit path requirements; };
        aliases = map (a: mkAliasBin wrapped a) (requirements.aliases or [ ]);
      in
      [ wrapped ] ++ aliases
    )
    |> lib.flatten;
}
