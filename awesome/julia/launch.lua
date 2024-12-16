local utils = require("julia.utils")
local gears = require("gears")
local awful = require("awful")

local M = {}

M.rofi = {
	launcher = utils.config_path() .. "rofi/launcher/launcher.sh",
	powermenu = utils.config_path() .. "rofi/powermenu/powermenu.sh",
	audiomenu = utils.config_path() .. "rofi/audiomenu/start.py",
	screenshotmenu = utils.config_path() .. "rofi/screenshotmenu/start.sh",
	displaymenu = utils.config_path() .. "rofi/displaymenu/start.sh",
}

local terminals = {
	wezterm = "org.wezfurlong",
	kitty = "kitty",
	alacritty = "Alacritty",
	xterm = "",
}

M.apps = {
	terminal = { executable = [[sh -c "wezterm || kitty"]], class = "org.wezfurlong.wezterm" },
	music = { executable = "spotify", class = "Spotify" },
	browser = { executable = "firefox", class = "firefox" },
	file_manager = { executable = "thunar", class = "Thunar" },
	editor = { executable = "nvim" },
}

--- TODO: fix this
--- @return App|nil
local function find_terminal()
	for term, class in ipairs(terminals) do
		awful.spawn.easy_async_with_shell("which " .. term, function(path)
			if path ~= nil then
				return { executable = path, class = class }
			end
		end)
	end

	return nil
end

-- Configuration ends here

---@param class string|nil
---@param pid string|nil
---@return boolean
local function focus_process(class, pid)
	local found = false

	for _, c in ipairs(client.get()) do
		local matches = c.class == class or c.pid == pid
		if matches and c.screen.index == 1 then
			c:jump_to()
			found = true
			break
		end
	end

	return found
end

---@class App
---@field executable string
---@field class string
local App = {}

---@param executable string
---@param class string
function App:new(executable, class)
	self.__index = self
	return setmetatable({
		executable = executable,
		class = class,
	}, self)
end

---@param self App
function App:focus()
	if client.focus then
		local already_focused = client.focus.class == self.class
		local same_screen = client.focus.screen.index == 1

		if already_focused and same_screen then
			awful.spawn(self.executable)
		end
	end

	local found = focus_process(self.class)
	if not found then
		local pid = awful.spawn(self.executable)
		local timer = gears.timer({})

		timer = gears.timer({
			timeout = 0.1,
			autostart = true,
			callback = function()
				if focus_process(nil, pid) then
					timer:stop()
				end
			end,
		})
	end
end

---@param apps table<string, App>
---@return App[]
local function create_classes(apps)
	local classes = {}

	for name, app in pairs(apps) do
		classes[name] = App:new(app.executable, app.class)
	end

	return classes
end

M.apps = create_classes(M.apps)

return M
