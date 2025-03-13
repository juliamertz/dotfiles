{ lib, ... }:
let
  mkImportList = path: lib.mapAttrsToList (name: _: path + "/${name}") (builtins.readDir path);
in
{
  imports =
    [
      ./plugins
      ./languages
      ./custom
    ]
    |> map mkImportList
    |> lib.concatLists;

  viAlias = true;
  vimAlias = true;

  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  opts = {
    nu = true;
    relativenumber = true;
    fileignorecase = true;

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
  extraConfigLuaPost = builtins.readFile ./term.lua;

  luaLoader.enable = true;
  performance.byteCompileLua = {
    enable = true;
    configs = true;
    initLua = true;
    nvimRuntime = true;
    plugins = true;
  };
}
