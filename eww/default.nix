{
  writeShellApplication,
  pkgs,
  lib,
  eww,
  ...
}: let
  openWidget = name: path: screen:
    writeShellApplication {
      name = "widget";
      runtimeInputs = with pkgs; [
        jq
        socat
      ];
      text = ''
        ${lib.getExe eww} --config ${path} open ${name} --screen ${builtins.toString screen}
      '';
    };
in
  # writeShellScriptBin "widget" # sh
  #   ''
  #     ${lib.getExe eww} --config ${path} open ${name} --screen ${builtins.toString screen}
  #   '';
  (openWidget "bar" ./bar 1)
