{ lib, config, ... }:
{
  plugins.yanky = {
    enable = true;
    autoLoad = true;
    settings = {
      highlight = {
        on_put = true;
        on_yank = true;
        timer = 100;
      };
      preserve_cursor_position.enabled = true;
      system_clipboard.sync_with_ring = false;
    };
  };

  keymaps = lib.optionals config.plugins.yanky.enable [
    {
      key = "p";
      action = "<Plug>(YankyPutAfter)";
      options.desc = "Put after";
    }
    {
      key = "P";
      action = "<Plug>(YankyPutBefore)";
      options.desc = "Put before";
    }
    {
      key = "<C-p>";
      action = "<Plug>(YankyPreviousEntry)";
      options.desc = "Cycle to previous clipboard entry";
    }
    {
      key = "<C-n>";
      action = "<Plug>(YankyNextEntry)";
      options.desc = "Cycle to next clipboard entry";
    }
  ];
}
