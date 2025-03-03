{ pkgs, lib, ... }:
{
  plugins = {
    # language server
    lsp.servers.lua_ls = {
      enable = true;
      settings = {
        runtime.version = "LuaJIT";
        signatureHelp.enabled = true;
        telemetry.enabled = false;
        diagnostics = {
          globals = [ "vim" ];
          disable = [ "missing-fields" ];
        };
      };
    };
    lazydev = {
      enable = true;
      settings = {
        library = [
          {
            path = "\${3rd}/luv/library";
            words = [ "vim%.uv" ];
          }
        ];
      };
    };

    # formatting
    conform-nvim.settings = {
      formatters_by_ft.lua = [ "stylua" ];
      formatters.stylua = {
        command = lib.getExe pkgs.stylua;
        stdin = false;
        args = [
          "$FILENAME"
          "--call-parentheses"
          "None"
          "--quote-style"
          "AutoPreferSingle"
        ];
      };
    };
  };
}
