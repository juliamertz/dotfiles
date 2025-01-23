{ lib, ... }:
{
  imports = lib.mapAttrsToList (name: _: ./plugins + "/${name}") (builtins.readDir ./plugins);

  vimAlias = true;
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  opts = {
    nu = true;
    relativenumber = true;

    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    expandtab = true;

    wrap = false;
    selection = "exclusive";
    swapfile = false;

    hlsearch = false;
    incsearch = true;

    termguicolors = true;
    scrolloff = 12;

    updatetime = 50;

    undofile = true;
    undolevels = 1000;
    undoreload = 10000;
  };

  extraConfigLuaPre = builtins.readFile ./config.lua;
  extraConfigLua = ''
    vim.wo.fillchars = "eob: "; -- remove tilde from empty lines
    vim.o.cmdheight = 0;
  '';

  # improve lua performance
  luaLoader.enable = true;
  performance.byteCompileLua = {
    enable = true;
    configs = true;
    initLua = true;
    nvimRuntime = true;
    plugins = true;
  };

  # FIX: this doesn't work
  # https://nix-community.github.io/nixvim/NeovimOptions/extraFiles/index.html#extrafiles
  # include custom treesitter queries
  # extraFiles."queries/go/injections.scm".source = ./queries/go/injections.scm;
}
