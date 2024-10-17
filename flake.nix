{
  description = "Programs I use wrapped with their configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { pkgs, lib, ... }:
        let
          wrappedProgram = path: pkgs.callPackage path { inherit wrapPackage; };
          wrapPackage =
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
            pkgs.symlinkJoin {
              inherit (cfg) name;
              paths = [ cfg.package ] ++ cfg.dependencies;
              buildInputs = [ pkgs.makeWrapper ];
              postBuild = ''
                ${cfg.preWrap}
                wrapProgram $out/bin/${cfg.name} \
                  --add-flags "${join cfg.extraFlags}" ${join cfg.extraArgs}
                ${cfg.postWrap}
              '';
            };

        in
        {
          packages.neovim = wrappedProgram ./nvim;
          packages.lazygit = wrappedProgram ./lazygit;
        };
    };
}
