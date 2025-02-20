{
  plugins = {
    lsp.servers.lua_ls.enable = true;

    lazydev.enable = true;
    blink-cmp.settings = {
      sources.providers = {
        lazydev = {
          name = "LazyDev";
          module = "lazydev.integrations.blink";
          score_offset = 100;
        };
      };
    };
  };
}
