{
  system,
  lib,
  inputs,
  ...
}:
let
  nixCats = import inputs.nixcats;
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ (import ./overlays.nix inputs) ];
  };

  categoryDefinitions = import ./categories.nix;
  packageDefinitions = {
    nvim = _: {
      settings = {
        wrapRc = true;
        aliases = [
          "vi"
          "vim"
        ];
      };
      categories = {
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
        zig = true;
        go = true;
        python = true;
        javascript = true;
        markdown = true;
      };
    };
  };
in
nixCats.baseBuilder ./. {
  inherit pkgs;
} categoryDefinitions packageDefinitions "nvim"
|> lib.setName "neovim"
