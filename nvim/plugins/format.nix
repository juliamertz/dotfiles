{ lib, pkgs, ... }:
{
  plugins.conform-nvim = {
    enable = true;

    settings = {
      notify_on_error = true;
      formatters_by_ft = {
        javascript = [ "prettierd" ];
        yaml = [ "yamlfmt" ];
      };

      formatters = {
        prettierd = {
          command = lib.getExe pkgs.prettierd;
        };
        yamlfmt = {
          command = lib.getExe pkgs.yamlfmt;
        };
      };
    };
  };

  extraConfigLua = ''
    vim.api.nvim_create_user_command('Format', function()
      require('conform').format {
        async = true,
        bufnr = 0,
        lsp_fallback = true,
      }
    end, {})
  '';

  keymaps = [
    {
      key = "<leader>ff";
      action = ":Format<CR>";
      options.desc = "Format current buffer";
    }
  ];
}
