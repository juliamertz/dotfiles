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
    formatters.nixfmt-rfc-style = {
      command = lib.getExe pkgs.black;
    };
  };
}
