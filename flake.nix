{
  description = "My favourite programs wrapped with their configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    alejandra.url = "github:kamadorueda/alejandra/4.0.0";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    spotify-player.url = "github:juliamertz/spotify-player/dev?dir=nix";
    spicetify.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    forAllSystems = func: nixpkgs.lib.genAttrs (import systems) (system: func nixpkgs.legacyPackages.${system});

    treefmtEval = forAllSystems (
      pkgs: inputs.treefmt-nix.lib.evalModule pkgs (import ./treefmt.nix (pkgs // {inherit inputs;}))
    );

    systemPrograms = attrs:
      forAllSystems (
        pkgs: let
          inherit
            (pkgs)
            lib
            stdenv
            system
            callPackage
            ;
          finalAttrs = attrs system;
          helpers = callPackage ./helpers.nix {inherit self;};
        in
          finalAttrs.all
          ++ lib.optionals stdenv.isLinux finalAttrs.linux
          ++ lib.optionals stdenv.isDarwin finalAttrs.darwin
          |> map (p:
            if lib.isPath p
            then helpers.callProgram p
            else p)
          |> map (p: {
            name = p.name;
            value = p;
          })
          |> lib.listToAttrs
      );
  in {
    packages = systemPrograms (system: {
      all = [
        ./nvim
        ./lazygit
        ./tmux
        ./spotify-player
        ./spotify
        ./wezterm
        ./kitty
        ./alacritty
        ./ghostty
        ./zsh
        ./git
        ./bat
        ./w3m
        ./awesome
        ./zathura
        ./scripts
      ];
      linux = [
        ./weechat
        ./picom
        ./btop
        ./eww
        ./rofi
      ];
      darwin = [
        ./sketchybar
        ./skhd
      ];
    });

    devShells = forAllSystems (
      pkgs:
        import ./shells.nix {
          inherit
            (pkgs)
            lib
            system
            mkShell
            pkgs
            ;

          packages = self.packages.${pkgs.system};
        }
    );

    formatter = forAllSystems (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
  };

  nixConfig = {
    extra-substituters = ["https://juliamertz.cachix.org"];
    extra-trusted-public-keys = [
      "juliamertz.cachix.org-1:l9jCGk7vAKU5kS07eulGJiEsZjluCG5HTczsY2IL2aw="
    ];
  };
}
