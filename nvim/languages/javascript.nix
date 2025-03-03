{ pkgs, lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  # language servers
  plugins.lsp.servers = {
    denols = {
      enable = true;
      settings = mkRaw ''
        {
          on_attach = on_attach,
          root_dir = require'lspconfig'.util.root_pattern("deno.json", "deno.jsonc"),
        }
      '';
    };

    ts_ls = {
      enable = true;
      settings = mkRaw ''
        {
          on_attach = on_attach,
          root_dir = require'lspconfig'.util.root_pattern("package.json"),
          single_file_support = false
        }
      '';
    };
  };

  # formatting
  plugins.conform-nvim.settings =
    let
      formatter = "prettierd";
    in
    {
      formatters_by_ft = {
        javascript = [ formatter ];
        typescript = [ formatter ];
      };

      formatters.${formatter} = {
        command = lib.getExe pkgs.${formatter};
      };
    };

}
