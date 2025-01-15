{ vimPlugins, ... }:
{
  plugins.harpoon = {
    enable = true;
    package = vimPlugins.harpoon2;
  };

  extraConfigLua = ''
    local harpoon = require 'harpoon'
    harpoon:setup()

    keymap('n', '<space>aa', function()
      harpoon:list():add()
    end)
    keymap('n', '<space>op', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    for _, idx in ipairs { 1, 2, 3, 4, 5 } do
      keymap('n', string.format('<space>%d', idx), function()
        harpoon:list():select(idx)
      end)
    end
  '';
}
