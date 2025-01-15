{
  plugins.undotree = {
    enable = true;
    settings = {
      float_diff = true;
      layout = "left_bottom";
      position = "left";
      ignore_filetype = [
        "undotree"
        "undotreeDiff"
        "qf"
        "TelescopePrompt"
        "spectre_panel"
        "tsplayground"
      ];
      window = {
        winblend = 30;
      };
      keymaps = {
        "j" = "move_next";
        "k" = "move_prev";
        "gj" = "move2parent";
        "J" = "move_change_next";
        "K" = "move_change_prev";
        "<cr>" = "action_enter";
        "p" = "enter_diffbuf";
        "q" = "quit";
      };
    };
  };

  extraConfigLua = ''
    vim.api.nvim_create_user_command('UndoTreeToggle', function()
      require('undotree').toggle()
    end, {})
  '';

  keymaps = [
    {
      key = "<leader>ut";
      action = ":UndoTreeToggle<CR>";
      # action.__raw = "require('undotree').toggle()";
      options.desc = "Toggle undotree pane";
    }
  ];
}
