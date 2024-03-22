-- pcall(require, "luarocks.loader")

local awful = require("awful")
local beautiful = require("beautiful")
local bar = require("djor.bar")
local style = require("djor.style")
local keys = require("djor.keys")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

require('djor.errors')
require('djor.keys')

beautiful.init(style.theme)

awful.layout.layouts = {
  awful.layout.suit.tile.left,   -- Used for main horizontal display
  awful.layout.suit.tile.bottom, -- Used for second vertical display
}

local layout_master_width_factors = {
  0.7,
  0.68
}

local tags = {
  "TERM",
  "WEB",
}

local screen_idx = 1
awful.screen.connect_for_each_screen(function(s)
  for i = 1, 4 do
    local tag_idx = (screen_idx - 1) * 4 + i
    local tag_name = tags[i] or tostring(tag_idx)

    awful.tag.add(tag_name, {
      screen = s,
      layout = awful.layout.layouts[screen_idx],
      master_width_factor = layout_master_width_factors[screen_idx],
      selected = i == 1
    })
  end

  style.wallpaper:init(s)
  if screen_idx == 1 then bar.init(s) end

  screen_idx = screen_idx + 1
end)

awful.rules.rules = {
  {
    rule = {},
    callback = awful.client.setslave,
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.clientkeys,
      buttons = keys.clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
  },

  {
    rule_any = {
      instance = {},
      class = {
        "Arandr",
      },
      name = {
        "Event Tester",
      },
      role = {
        "pop-up",
      }
    },
    properties = { floating = true }
  },

  -- {
  --   rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "WEB" }
  -- },
}

-- Mouse follows focus
require("plugins.micky")
-- Focus follows mouse
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
screen.connect_signal("property::geometry", style.wallpaper.init)
