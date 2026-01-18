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
      packages = self.packages.${pkgs.stdenv.hostPlatform.system};
      inherit (self) inputs;
      inherit
        wrapPackage
        readNixFiles
        mkImportList
        importUnfree
        callProgram
        decToHex
        fetchGithubFlake
        ;
    };

  wrapPackage = {
    package,
    name ? null,
    extraArgs ? "",
    extraFlags ? "",
    appendFlags ? "",
    dependencies ? [],
    preWrap ? "",
    postWrap ? "",
    # absolute paths from $out to file you want to wrap e.g. /bin/tmux
    wrapPaths ? ["/bin/${package.meta.mainProgram}"],
    extraWrapPaths ? [],
  }: let
    inherit (package.meta) mainProgram;
    join = value:
      if builtins.isList value
      then lib.concatStringsSep " " value
      else value;
  in
    symlinkJoin {
      name =
        if builtins.isNull name
        then mainProgram
        else name;

      paths = [package] ++ dependencies;
      buildInputs = [makeWrapper];

      postBuild = let
        perPath = path:
        #sh
        ''
          ${preWrap}
          wrapProgram "$out${path}" \
            --add-flags "${join extraFlags}" \
            --append-flags "${join appendFlags}" \
            ${join extraArgs}
          ${postWrap}
        '';
      in
        wrapPaths
        ++ extraWrapPaths
        |> map perPath
        |> lib.concatStringsSep "\n";

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
    system = pkgs.stdenv.hostPlatform.system;
    flake = with opts; builtins.getFlake "github:${owner}/${repo}/${rev}";
  in {
    packages = flake.packages.${system};
  };

  decToHex = let
    intToHex = ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f"];
    toHex' = q: a:
      if q > 0
      then
        (toHex'
          (q / 16)
          ((lib.elemAt intToHex (lib.mod q 16)) + a))
      else a;
  in
    v: toHex' v "";
}
