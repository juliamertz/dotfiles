{ lib, config, ... }:
{
  plugins.telescope = {
    enable = true;

    settings = {
      extensions = {
        fzf = {
          fuzzy = true;
          override_generic_sorter = true;
          override_file_sorter = true;
        };
      };
      defaults = {
        layout_strategy = "horizontal";
        layout_config.__raw = ''
          {
            preview_cutoff = 64,
            width = function(_, cols, _)
              return cols
            end,
            height = function(_, _, rows)
              return rows
            end,
            preview_width = function(_, cols, _)
              return math.floor((cols / 5) * 3)
            end
          }
        '';
      };
    };

  };

  keymaps = let picker = kind: "<cmd>Telescope ${kind}<CR>"; in
    lib.optionals config.plugins.telescope.enable [
      {
        key = "<leader>pf";
        action = picker "find_files";
        options.desc = "Find files";
      }
      {
        key = "<leader>gs";
        action = picker "live_grep";
        options.desc = "Live grep";
      }
      {
        key = "<leader>vws";
        action = picker "lsp_workspace_symbols";
        options.desc = "Find workspace symbol";
      }
      {
        key = "<leader>ht";
        action = picker "help_tags";
        options.desc = "Help pages";
      }
    ];
}
