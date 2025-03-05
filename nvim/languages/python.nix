{
  pkgs,
  lib,
  ...
}:
{
  plugins.lsp.servers.basedpyright = {
    enable = true;
    settings = { };
  };

  # formatting
  plugins.conform-nvim.settings = {
    formatters_by_ft.python = [ "black" ];
    formatters.black = {
      command = lib.getExe pkgs.black;
    };
  };
}
