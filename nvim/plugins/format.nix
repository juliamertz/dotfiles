{ lib, pkgs, ... }:
{
  plugins.conform-nvim = {
    enable = true;

    settings = {
      notify_on_error = true;
      formatters_by_ft = {
        nix = [ "nixfmt-rfc-style" ];
        lua = [ "stylua" ];
        javascript = [ "prettierd" ];
        yaml = [ "yamlfmt" ];
      };

      formatters = {
        nixfmt-rfc-style = {
          command = lib.getExe pkgs.nixfmt-rfc-style;
        };
        prettierd = {
          command = lib.getExe pkgs.prettierd;
        };
        stylua = {
          command = lib.getExe pkgs.stylua;
          args = [
            "$FILENAME"
            "--call-parentheses"
            "None"
            "--quote-style"
            "AutoPreferSingle"
          ];
        };
        yamlfmt = {
          command = lib.getExe pkgs.yamlfmt;
        };
      };

    };
  };
}
