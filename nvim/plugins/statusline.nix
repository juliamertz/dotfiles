{
  plugins.mini.modules.statusline = {
    use_icons = true;
    set_vim_settings = true;

    content = {
      inactive = null;
      active.__raw = ''
        function()
          local check_macro_recording = function()
            if vim.fn.reg_recording() ~= "" then
              return "Recording @" .. vim.fn.reg_recording()
            else
              return ""
            end
          end

          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diff = MiniStatusline.section_diff({ trunc_width = 75 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          -- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local location = MiniStatusline.section_location({ trunc_width = 200 })
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
          local macro = check_macro_recording()

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
            "%<", -- Mark general truncate point
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineFilename", strings = { macro } },
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          })
        end,
      '';
    };
  };
}
