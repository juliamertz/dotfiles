{
  lib,
  writeText,
  runCommandNoCC,
  linkFarm,

  buildNpmPackage,
  importNpmLock,
  ...
}:
rec {

  mkConfig =
    path: options:
    let
      finalOpts = options // {
        "$schema" = "https://github.com/glzr-io/zebar/raw/v2.4.0/resources/settings-schema.json";
      };
      settings = writeText "settings.json" (lib.strings.toJSON finalOpts);
    in
    runCommandNoCC "zebar-config" { } ''
      mkdir -p $out
      ln -sf ${settings} $out/settings.json

      for widget in ${buildWidgets path}/*; do
        ln -sf $widget $out/$(basename $widget)
      done
    '';

  buildWidget =
    name: path:
    let
      source = buildNpmPackage {
        inherit name;
        src = path;

        npmDeps = importNpmLock { npmRoot = path; };
        npmConfigHook = importNpmLock.npmConfigHook;
      };
    in
    runCommandNoCC "widget-${name}" { } ''
      ln -sf ${source}/lib/node_modules/${name}/build $out
    '';

  optionalBuild =
    name: path:
    let
      entries = builtins.readDir path |> lib.attrsToList |> map ({ name, ... }: name);
      needsBuild = builtins.elem "package.json" entries;
    in
    if needsBuild then buildWidget name path else path;

  buildWidgets =
    path:
    builtins.readDir path
    |> lib.attrsToList
    |> builtins.filter ({ name, value }: value == "directory")
    |> map ({ name, ... }: name)
    |> map (name: {
      inherit name;
      path = optionalBuild name (path + "/${name}");
    })
    |> linkFarm "zebar-widgets";
}
