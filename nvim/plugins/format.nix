{ lib, pkgs, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = true;
      formatters_by_ft = {
        yaml = [ "yamlfmt" ];
      };

      formatters = {
        yamlfmt = {
          command = lib.getExe pkgs.yamlfmt;
        };
      };
    };
  };

  keymaps = [
    {
      key = "<leader>ff";
      action = "<cmd>Format<CR>";
      options.desc = "Format current buffer";
    }
  ];

  extraConfigLua = ''
    vim.api.nvim_create_user_command('Format', function()
      require('conform').format {
        async = true,
        bufnr = 0,
        lsp_fallback = true,
      }
    end, {})
  '';
}
