{ lib, ... }:
{
  imports = builtins.readDir ./plugins |> lib.mapAttrsToList (name: _: ./plugins + "/${name}");

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
    # vim.wo.fillchars = "eob: "; # remove tilde from empty lines
    # vim.o.cmdheight = 0;

    undofile = true;
    undolevels = 1000;
    undoreload = 10000;
  };

  # improve lua performance
  luaLoader.enable = true;
  performance.byteCompileLua = {
    enable = true;
    configs = true;
    initLua = true;
    nvimRuntime = true;
    plugins = true;
  };
}
