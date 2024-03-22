local naughty = require("naughty")
local utils = require("djor.utils")

return {
  terminal       = 'wezterm',
  music          = 'spotify',
  browser        = 'firefox',
  file_manager   = 'thunar',
  editor         = 'nvim',

  -- Rofi launchers
  launcher       = utils.config_path() .. 'rofi/launcher/launcher.sh',
  powermenu      = utils.config_path() .. 'rofi/powermenu/powermenu.sh',
  audiomenu      = utils.config_path() .. 'rofi/audiomenu/start.py',
  screenshotmenu = utils.config_path() .. 'rofi/screenshotmenu/start.sh',
  displaymenu    = utils.config_path() .. 'rofi/displaymenu/start.sh',
}
