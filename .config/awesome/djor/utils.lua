local naughty = require("naughty")
local gears = require("gears")
local inspect = require("plugins.inspect")
local style = require("djor.style")
local filesystem = require("gears.filesystem")

local M = {
  inspect = inspect
}

---@return string
M.config_path = function()
  return filesystem.get_configuration_dir():gsub("awesome/", "")
end


---@param text string
---@param color string|nil
---@param font string|nil
---@param escape boolean|nil
---@return string
M.html_text_style = function(text, color, font, escape)
  color = color or style.colors.text
  font = font or style.theme.font
  text = escape and text or gears.string.xml_escape(text)
  return "<span color=\"" .. color .. "\" font=\"" .. font .. "\">" .. text .. "</span>"
end

---@param str string
---@param seperator string
---@return table
M.split_str = function(str, seperator)
  local result = {}
  for part in string.gmatch(str, "([^" .. seperator .. "]+)") do
    table.insert(result, part)
  end

  return result
end

---@param str string
---@return string
M.trim = function(str)
  local result = str:gsub("^%s*(.-)%s*$", "%1")
  return result
end

---@param msg any
---@param title string|nil
M.debug = function(msg, title)
  naughty.notify({
    title = "Debug: " .. (title or ""),
    text = inspect(msg)
  })
end

return M
