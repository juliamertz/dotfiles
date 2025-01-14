{
  plugins = {
    fzf-lua = {
      enable = true;
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

    telescope.enable = true;
    todo-comments = {
      enable = true;
      keymaps = {
        todoTelescope = {
          key = "<leader>td";
          keywords = [ "TODO" ];
        };
      };
    };
  };
}
