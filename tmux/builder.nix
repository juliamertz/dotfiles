{
  lib,
  writeText,
  runCommandNoCC,
  stdenvNoCC,
  makeWrapper,
  tmux,
  ...
}: rec {
  makeTmuxConfig = {
    # Global variables
    globals ? {},
    # Environment variables
    environment ? {},
    # List of tmux plugin packages
    plugins ? [],
    # Global plugin options to be prefixed by a '@'
    pluginOptions ? {},
    # Source these tmux conf files at runtime
    sourceFiles ? [],
    # Extra raw tmux config
    extraConfig ? "",
    # Reset XDG_CONFIG_HOME back to "$HOME/.config" after initialization
    patchXdgConfig ? false,
    ...
  }: let
    inherit (lib) mapAttrsToList optionalString;
    joinLines = lib.concatStringsSep "\n";
    setGlobal = key: value: "set -g ${key} ${value}";
    setEnv = key: value: "set-environment -g ${key} ${value}";
    sourcePlugin = p: "run-shell ${p}/share/tmux-plugins/${p.pluginName}/${p.pluginName}.tmux";

    sourceFilesText = map (path: "source-file ${path}") sourceFiles |> joinLines;
    setGlobalsText = mapAttrsToList setGlobal globals |> joinLines;
    setPluginOptionsText = mapAttrsToList (k: v: setGlobal "@${k}" v) pluginOptions |> joinLines;
    sourcePluginsText = map sourcePlugin plugins |> joinLines;
    setEnvironmentText = mapAttrsToList setEnv environment |> joinLines;
    patchXdgConfigHomeText = optionalString patchXdgConfig <| setEnv "XDG_CONFIG_HOME" "$HOME/.config";
  in
    writeText "tmux.conf" (joinLines [
      sourceFilesText
      setGlobalsText
      setPluginOptionsText
      sourcePluginsText
      setEnvironmentText
      extraConfig
      patchXdgConfigHomeText
    ]);

  makeTmuxConfigDir = opts:
    runCommandNoCC (opts.name or "tmux-config") {} ''
      mkdir -p $out/tmux
      ln -svf ${makeTmuxConfig opts} $out/tmux/tmux.conf
    '';

  makeTmuxBin = opts: let
    config = makeTmuxConfigDir opts;
    package = opts.package or tmux;
  in
    stdenvNoCC.mkDerivation {
      name = "tmux";
      src = package;
      buildInputs = [makeWrapper];

      buildPhase = ''
        mkdir -p $out/bin
        ln -s ${package}/bin/tmux $out/bin/tmux
      '';

      installPhase = ''
        wrapProgram $out/bin/tmux \
          --set XDG_CONFIG_HOME '${config}' \
          --add-flags "${[
            "-u" # fixes nerdfont rendering over ssh in some cases, see: https://stackoverflow.com/a/70033785
            "-f ${config}/tmux/tmux.conf"
          ]
          |> lib.concatStringsSep " "}"
      '';

      meta.mainProgram = "tmux";
    };
}
