{
  extraConfigLuaPost = builtins.readFile ../snippets.lua;

  plugins = {
    luasnip = {
      enable = true;
      # fromLua = [
      #   {
      #     paths = ../snippets;
      #   }
      # ];
    };


    blink-cmp = {
      enable = true;

      settings = {
        completion = {
          documentation = {
            auto_show = true;
            window.border = "rounded";
          };
        };
        fuzzy = {
          prebuilt_binaries = {
            download = false;
            ignore_version_mismatch = true;
          };
        };
        keymap = {
          preset = "none";
          "<C-space>" = [
            "show"
            "show_documentation"
            "hide_documentation"
          ];
          "<C-e>" = [ "hide" ];
          "<C-y>" = [ "select_and_accept" ];
          "<C-p>" = [
            "select_prev"
            "fallback"
          ];
          "<C-n>" = [
            "select_next"
            "fallback"
          ];
          "<C-b>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-f>" = [
            "scroll_documentation_down"
            "fallback"
          ];
        };
        signature = {
          enabled = true;
          window.border = "rounded";
        };

        snippets = {
          preset = "luasnip";
        };
        sources = {
          default = [
            "lsp"
            "buffer"
            "snippets"
            "path"
          ];
          providers = {
            lsp.score_offset = 4;
          };
        };
      };
    };
  };
}
