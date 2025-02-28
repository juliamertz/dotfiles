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
      src = pkgs.fetchFromGitHub {
        owner = "juliamertz";
        repo = "godoc.nvim";
        rev = "4317f8b27e84b0a1453407f9ad64a092aff06b89";
        hash = "sha256-Wr+dxxxPJNbZMevLPseWLnm8XPcoFa11yTo1s3u0yKY=";
      };
    })
  ];
}
