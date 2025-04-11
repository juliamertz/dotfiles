{
  lib,
  pkgs,
  system,
  symlinkJoin,
  makeWrapper,
  self,
}: rec {
  callProgram = path:
    pkgs.callPackage path {
      packages = self.packages.${pkgs.system};
      inherit (self) inputs;
      inherit
        wrapPackage
        readNixFiles
        mkImportList
        importUnfree
        callProgram
        fetchGithubFlake
        ;
    };

  wrapPackage = args: let
    cfg = (
      lib.mergeAttrs {
        extraFlags = "";
        appendFlags = "";
        extraArgs = "";
        dependencies = [];
        postWrap = "";
        preWrap = "";
      }
      args
    );

    inherit (cfg.package.meta) mainProgram;
    join = value:
      if builtins.isList value
      then lib.concatStringsSep " " value
      else value;
  in
    symlinkJoin {
      name = args.name or mainProgram;
      paths = [cfg.package] ++ cfg.dependencies;
      buildInputs = [makeWrapper];

      postBuild = ''
        ${cfg.preWrap}
        wrapProgram $out/bin/${mainProgram} \
          --add-flags "${join cfg.extraFlags}" \
          --append-flags "${join cfg.appendFlags}" \
          ${join cfg.extraArgs}
        ${cfg.postWrap}
      '';

      meta.mainProgram = mainProgram;
    };

  # Filter out default.nix and non-.nix files
  readNixFiles = path: let
    isNix = name: name != "default.nix" && builtins.match ".*\\.nix" name != null;
    files = builtins.readDir path;
  in
    builtins.filter isNix (builtins.attrNames files);

  mkImportList = path: lib.mapAttrsToList (name: _: path + "/${name}") (builtins.readDir path);

  # import nixpkgs with `config.allowUnfree = true;`
  importUnfree = input:
    import input {
      inherit system;
      config.allowUnfree = true;
    };

  fetchGithubFlake = opts: let
    system = pkgs.system;
    flake = with opts; builtins.getFlake "github:${owner}/${repo}/${rev}";
  in {
    packages = flake.packages.${system};
  };
}
