{
  plugins.mini = {
    enable = true;
    mockDevIcons = true;

    modules = {
      icons = { };
      git = { };

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
