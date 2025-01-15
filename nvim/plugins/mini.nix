{
  plugins.mini = {
    enable = true;

    # emulate nvim-web-devicons for plugins that don’t natively support it.
    mockDevIcons = true;

    modules = {
      icons = { };
      git = { };

      statusline = {
        content = {
          active = null;
          inactive = null;
        };
        use_icons = true;
        set_vim_settings = true;
      };

      surround = {
        mappings = {
          add = "ys";
          delete = "ds";
          replace = "cs";
          find = "";
          find_left = "";
          highlight = "";
          update_n_lines = "";
          suffix_last = "";
          suffix_next = "";
        };
      };

    };
  };

  extraConfigLua = ''
    -- Disable statusline for certain filetypes
    vim.api.nvim_create_autocmd('Filetype', {
      callback = function(args)
        local disabled_filetypes = { 'man', 'NvimTree', 'oil' }
        if vim.tbl_contains(disabled_filetypes, vim.bo[args.buf].filetype) then
          vim.b[args.buf].ministatusline_disable = true
        end
      end,
    })
  '';
}
