{
  pkgs,
  lib,
  system,
  inputs,
  ...
}:
let
  inherit (lib.nixvim) toLuaObject mkRaw;
  settings = {
    picker.type = "telescope";
    window.type = "vsplit";
    adapters = [
      { name = "go"; }
      {
        name = "nix";
        setup = mkRaw "function() return require('noogle').setup() end";
      }
    ];
  };
in
{
  keymaps = [
    {
      key = "<leader>gd";
      action = "<cmd>GoDoc<cr>";
      options.desc = "Search go documentation";
    }
    {
      key = "<leader>nd";
      action = "<cmd>Noogle<cr>";
      options.desc = "Search nix documentation";
    }
  ];

  extraConfigLua = ''
    local godoc = require 'godoc'
    godoc.setup ${toLuaObject settings}
  '';

  extraPlugins = [
    inputs.noogle.packages.${system}.noogle-nvim

    (pkgs.vimUtils.buildVimPlugin {
      name = "godoc";
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
    })
  ];
}
