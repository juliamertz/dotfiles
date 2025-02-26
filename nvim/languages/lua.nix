{
  plugins = {
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

    blink-cmp.settings.sources = {
      default = [ "lazydev" ];
      providers = {
        lazydev = {
          name = "LazyDev";
          module = "lazydev.integrations.blink";
          score_offset = 100;
        };
      };
    };
  };
}
