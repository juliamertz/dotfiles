{
  plugins.fzf-lua = {
    enable = true;
    settings = {
      winopts = {
        height = 1.00;
        width = 1.00;
        row = 0.0;
        col = 0.0;
      };
    };
    keymaps = {
      "<leader>pf" = {
        action = "files";
        options.desc = "Find files";
      };
      "<leader>ht" = {
        action = "help_tags";
        options.desc = "Help Pages";
      };
      "<leader>gs" = {
        action = "live_grep";
        options.desc = "Live Grep";
      };
    };
  };
}
