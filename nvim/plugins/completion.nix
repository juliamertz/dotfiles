{ inputs, pkgs, ... }:
{
  plugins.blink-cmp = {
    enable = true;
    package = inputs.blink.packages.${pkgs.system}.blink-cmp;

    settings = {
      completion = {
        documentation = {
          auto_show = true;
          window.border = "rounded";
        };
      };
      snippets.preset = "luasnip";
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
      fuzzy.implementation = "prefer_rust";
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
    };
  };
}
