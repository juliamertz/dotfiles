{
  plugins.nvim-tree = {
    enable = true;
    extraOptions = {
      sort_by = "extension";
      view = {
        side = "right";
        width = 30;
      };
      renderer = {
        group_empty = true;
      };
      notify = {
        threshold.__raw = "vim.log.levels.ERROR";
      };
      filters = {
        dotfiles = false;
      };
    };
  };

  keymaps = [
    {
      action = "<cmd>NvimTreeToggle<CR>";
      key = "<C-b>";
      mode = "n";
      options = {
        desc = "Toggle file tree";
      };
    }
  ];
}
