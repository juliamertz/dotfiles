{
  lib,
  pkgs,
  symlinkJoin,
  runCommandNoCC,
  makeWrapper,
  inputs,
  packages,
}:
rec {
  mkProgram =
    path:
    pkgs.callPackage path {
      inherit
        inputs
        wrapPackage
        combineDerivations
        readNixFiles
        mkImports
        packages
        ;
    };

  combineDerivations =
    name: derivations:
    let
      copy =
        der: # sh
        "cp -r ${der} $out/${der.repo}";
      commands = map copy derivations;
    in
    runCommandNoCC name { } ''
      mkdir $out
      ${lib.concatStringsSep "\n" commands}
    '';

  wrapPackage =
    args:
    let
      cfg = (
        lib.mergeAttrs {
          extraFlags = "";
          extraArgs = "";
          dependencies = [ ];
          postWrap = "";
          preWrap = "";
        } args
      );

      inherit (cfg.package.meta) mainProgram;
      join = value: if builtins.isList value then lib.concatStringsSep " " value else value;
    in
    symlinkJoin {
      name = mainProgram;
      paths = [ cfg.package ] ++ cfg.dependencies;
      buildInputs = [ makeWrapper ];

      postBuild = ''
        ${cfg.preWrap}
        wrapProgram $out/bin/${mainProgram} \
          --add-flags "${join cfg.extraFlags}" ${join cfg.extraArgs}
        ${cfg.postWrap}
      '';

      inherit (cfg.package) meta;
    };

  # Filter out default.nix and non-.nix files
  readNixFiles =
    path:
    let
      isNix = name: name != "default.nix" && builtins.match ".*\\.nix" name != null;
      files = builtins.readDir path;
    in
    builtins.filter isNix (builtins.attrNames files);

  mkImports = path: files: map (name: path + "/${name}") files;
}
