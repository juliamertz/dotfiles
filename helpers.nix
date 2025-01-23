{
  lib,
  pkgs,
  symlinkJoin,
  runCommandNoCC,
  makeWrapper,
  inputs,
}:
rec {
  mkProgram =
    path:
    pkgs.callPackage path {
      inherit inputs wrapPackage combineDerivations;
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

      inherit (cfg.package.meta)mainProgram;
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

      meta.mainProgram = cfg.name;
    };
}
