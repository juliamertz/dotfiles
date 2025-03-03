{
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
{
  imports = [
    (lib.nixvim.plugins.mkNeovimPlugin {
      name = "godoc";
      package = "godoc";
      packPathName = "godoc.nvim";
      settingsOptions = { };
      maintainers = with maintainers; [ juliamertz ];
    })
  ];

  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins = prev.vimPlugins // {
        godoc = pkgs.vimUtils.buildVimPlugin {
          name = "godoc.nvim";
          src = inputs.godoc;
          nvimSkipModule = [
            "godoc"
            "godoc.pickers.init"
            "godoc.pickers.telescope"
            "godoc.pickers.snacks"
            "godoc.pickers.fzf_lua"
            "godoc.adapters.init"
            "godoc.adapters.go"
          ];
        };
      };
    })
  ];
}
