{
  pkgs,
  lib,
  linkFarm,
  writeText,
  runCommandNoCC,
  stdenvNoCC,
  makeWrapper,
  ...
}: rec {
  toShell = val:
    if lib.isAttrs val
    then let
      fields = lib.mapAttrsToList (key: value: ''["${key}"]=${toShell value}'') val;
    in "(${lib.concatStringsSep " " fields})"
    else if lib.isBool val
    then lib.boolToString val
    else builtins.toString val;

  pluginLinkFarm = pkgs:
    map (pkg: {
      name = "${pkg.repo}";
      path = pkg;
    })
    pkgs
    |> linkFarm "zsh-plugins";

  buildShell = {
    package ? pkgs.zsh,
    configDir,
    categoryDefinitions ? {},
    packageDefinitions ? {},
  }: let
    mergeEnabledCats = definitions: let
      values =
        lib.mapAttrsToList (
          key: value:
            if packageDefinitions.categories.${key} == true
            then value
            else []
        )
        definitions;
    in
      if lib.isList (lib.elemAt values 0)
      then lib.flatten values
      else lib.mergeAttrsList values;

    zshrc = writeText ".zshrc" (
      ''
        declare -A shellCats=${toShell packageDefinitions.categories}
      ''
      + builtins.readFile "${configDir}/.zshrc"
    );

    config = runCommandNoCC "zsh-config" {} ''
      mkdir -p $out

      ln -svf ${zshrc} $out/.zshrc
      ln -svf ${configDir}/*.zsh $out
    '';

    plugins = pluginLinkFarm (mergeEnabledCats categoryDefinitions.pluginPackages);

    environment =
      {
        ZDOTDIR = config;
        SHELLCATS_CONFIG = config;
        SHELLCATS_PLUGINS = plugins;
        SHELLCATS_EXTRAPATH = lib.makeBinPath (mergeEnabledCats categoryDefinitions.runtimeDeps);
      }
      // mergeEnabledCats categoryDefinitions.environmentVariables;
  in
    stdenvNoCC.mkDerivation {
      name = "zsh";
      src = package;
      buildInputs = [makeWrapper];

      unpackPhase = ''
        mkdir -p $out
        cp -r ${pkgs.zsh}/etc ${pkgs.zsh}/lib ${pkgs.zsh}/share $out
      '';

      buildPhase = ''
        mkdir -p $out/bin
        ln -s ${lib.getExe package} $out/bin/zsh
      '';

      installPhase = with lib;
      # sh
        ''
          wrapProgram $out/bin/zsh \
            ${mapAttrsToList (key: value: "--set ${key} '${value}'") environment |> concatStringsSep " "}
        '';

      meta = {
        platforms = lib.platforms.unix;
        mainProgram = "zsh";
      };

      passthru = {
        shellPath = "/bin/zsh";
      };
    };
}
