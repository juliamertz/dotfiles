{
  lib,
  pkgs,
  symlinkJoin,
  runCommandNoCC,
  makeWrapper,
}:
{
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

      join = value: if builtins.isList value then lib.concatStringsSep " " value else value;
    in
    symlinkJoin {
      inherit (cfg) name;
      paths = [ cfg.package ] ++ cfg.dependencies;
      buildInputs = [ makeWrapper ];

      postBuild = ''
        ${cfg.preWrap}
        wrapProgram $out/bin/${cfg.name} \
          --add-flags "${join cfg.extraFlags}" ${join cfg.extraArgs}
        ${cfg.postWrap}
      '';

      meta.mainProgram = cfg.name;
    };

}
