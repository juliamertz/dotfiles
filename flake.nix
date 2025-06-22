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
      nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin" "aarch64-linux"]
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
          // lib.optionalAttrs stdenv.isLinux finalAttrs.linux
          // lib.optionalAttrs stdenv.isDarwin finalAttrs.darwin
          |> lib.mapAttrs (_: package:
            if lib.isPath package
            then helpers.callProgram package
            else package)
      );
  in {
    packages = systemPrograms (system: {
      all = {
        neovim = ./nvim;
        neovim-minimal = self.packages.${system}.neovim.withCats {
          ai = false;
          folke = false;
          clipboard = false;
          docs = false;
          rust = false;
          zig = false;
          python = false;
          javascript = false;
          go = false;
        };
        emacs = ./emacs;
        lazygit = ./lazygit;
        tmux = ./tmux;
        spotify-player = ./spotify-player;
        spotify = ./spotify;
        # alacritty = # ./alacritty;
        # ghostty = # ./ghostty;
        wezterm = ./wezterm;
        kitty = ./kitty;
        zsh = ./zsh;
        fish = ./fish;
        starship = ./starship;
        git = ./git;
        bat = ./bat;
        w3m = ./w3m;
        zathura = ./zathura;
        scripts = ./scripts;
      };
      linux = {
        weechat = ./weechat;
        awesome = ./awesome;
        picom = ./picom;
        btop = ./btop;
        eww = ./eww;
        rofi = ./rofi;
      };
      darwin = {
        aerospace = ./aerospace;
        sketchybar = ./sketchybar;
        jankyborders = ./jankyborders;
        skhd = ./skhd;
      };
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
