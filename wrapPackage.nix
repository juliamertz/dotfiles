{ lib, symlinkJoin, makeWrapper }:
args:
let
  cfg = {
    extraFlags = "";
    extraArgs = "";
    dependencies = [ ];
    postWrap = "";
    preWrap = "";
  } // args;

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
}
