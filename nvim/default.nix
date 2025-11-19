{
  system,
  lib,
  inputs,
  callPackage,
  ...
}: let
  pins = callPackage ./pins.nix {};
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      (import ./overlays.nix {
        sources = pins.sources;
        inherit inputs;
      })
    ];
  };

  nixCats = import pins.sources.nixcats;
  categoryDefinitions = import ./categories.nix;
  packageDefinitions = categories: {
    nvim = _: {
      settings = {
        wrapRc = true;
        aliases = [
          "vi"
          "vim"
        ];
      };
      inherit categories;
    };
  };

  defaultCats = {
    general = true;
    have_nerd_font = false;

    theme = true;
    clipboard = true;
    oil = true;
    git = true;
    folke = true;
    mini = true;
    undotree = true;
    docs = true;
    harpoon = true;
    fuzzyfinder = true;
    filetree = true;
    treesitter = true;
    completion = true;
    colors = true;
    debug = true;

    # languages
    lua = true;
    nix = true;
    rust = true;
    ocaml = true;
    zig = true;
    go = true;
    python = true;
    javascript = true;
    markdown = true;
    yaml = true;
    toml = true;
    kcl = true;
    terraform = true;
    shell = true;
  };

  buildNeovim = categories: let
    builder =
      nixCats.baseBuilder ./. {inherit pkgs;};
  in
    builder categoryDefinitions (packageDefinitions categories) "nvim"
    |> lib.setName "neovim";
in
  (buildNeovim defaultCats)
  // {
    withCats = extraCats: buildNeovim (defaultCats // extraCats);
  }
