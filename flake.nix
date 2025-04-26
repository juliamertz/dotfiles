{
  description = "My favourite programs wrapped with their configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    spotify-player.url = "github:juliamertz/spotify-player/dev?dir=nix";
    spicetify.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    forAllSystems = func:
      nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin"]
      (system: func nixpkgs.legacyPackages.${system});

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
        # ./alacritty
        ./wezterm
        ./kitty
        # package is broken at the moment.
        # ./ghostty
        ./zsh
        ./git
        ./bat
        ./w3m
        ./zathura
        ./scripts
      ];
      linux = [
        ./weechat
        ./awesome
        ./picom
        ./btop
        ./eww
        ./rofi
      ];
      darwin = [
        ./aerospace
        ./sketchybar
        ./skhd
      ];
    });

    checks = self.packages;

    devShells = forAllSystems (
      pkgs:
        import ./shells.nix {
          packages = self.packages.${pkgs.system};
          inherit inputs;
          inherit (pkgs) lib system mkShell pkgs;
        }
    );
  };

  nixConfig = {
    extra-substituters = ["https://juliamertz.cachix.org"];
    extra-trusted-public-keys = [
      "juliamertz.cachix.org-1:l9jCGk7vAKU5kS07eulGJiEsZjluCG5HTczsY2IL2aw="
    ];
  };
}
