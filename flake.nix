{
  description = "My favourite programs wrapped with their configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    spotify-player.url = "github:juliamertz/spotify-player/dev?dir=nix";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    { self, nixpkgs, systems, ... }:
    let
      forAllSystems = func:
        nixpkgs.lib.genAttrs (import systems) (system: func nixpkgs.legacyPackages.${system});

      systemPrograms = attrs:
        forAllSystems (pkgs:
          let
            inherit (pkgs) lib stdenv callPackage;
            helpers = callPackage ./helpers.nix { inherit self; };
          in
          attrs.all ++ lib.optionals stdenv.isLinux attrs.linux ++ lib.optionals stdenv.isDarwin attrs.darwin 
          |> map helpers.callProgram
          |> map (p: { name = p.name; value = p; })
          |> lib.listToAttrs
        );
    in
    {
      packages = systemPrograms {
        all = [
          ./nvim
          ./lazygit
          ./tmux
          ./spotify-player
          ./wezterm
          ./kitty
          ./alacritty
          ./zsh
          ./w3m
          ./zathura
          ./scripts
        ];
        linux = [
          ./weechat
          ./picom
          ./btop
          ./eww
        ];
        darwin = [
          ./sketchybar
          ./skhd
        ];
      };

      devShells = forAllSystems (pkgs:
        import ./shells.nix {
          inherit (pkgs) lib system mkShell pkgs;
          packages = self.packages.${pkgs.system};
        }
      );
    };

  nixConfig = {
    extra-substituters = [ "https://juliamertz.cachix.org" ];
    extra-trusted-public-keys = [ "juliamertz.cachix.org-1:l9jCGk7vAKU5kS07eulGJiEsZjluCG5HTczsY2IL2aw=" ];
  };
}
