# My dotfiles

this is my workflow described and exported from one single repo through the power of nix.

## Running with nix

if you want to try a specific program all you need is the [nix](https://nixos.org/) package manager or [nix-portable](https://github.com/DavHau/nix-portable) if you can't / don't want to install nix.
for a full list of exported programs you can run, have a look in [flake.nix](./flake.nix).

```sh
# run neovim config without installing
nix run github:juliamertz/dotfiles#neovim
```

to enter a full fledged development environment with tmux, neovim, lazygit and a terminal emulator:

```sh
nix develop github:juliamertz/dotfiles#minimal
```

## Include in NixOS/Nix-Darwin system configuration

To avoid having to call nix everytime i want to use some program it's easier to build it once.
Assuming you're using [flakes](https://wiki.nixos.org/wiki/Flakes), add this repository as an input e.g.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dotfiles = {
      url = "github:juliamertz/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  ...
}
```

Then you can add these programs to your environment like this

```nix
{ inputs, pkgs, ... }:
let
  dotfiles = inputs.dotfiles.packages.${pkgs.system};
in
{
  environment.systemPackages = with dotfiles; [
    neovim
    kitty
    lazygit
    tmux
  ];
}
```

Sometimes you need direct access to the configuration, for example my window-manager configurations.
these can simply be accessed like this, it's up to you how this is included in your system config.

```nix
{ inputs, ... }:
{
  home.file.".config/awesome" = {
    source = "${inputs.dotfiles}/awesome";
    recursive = true;
  };
}
```
