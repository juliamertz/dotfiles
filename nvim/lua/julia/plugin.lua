local utils = require 'julia.utils'

local plugin_path = vim.env.NVIM_PLUGIN_DIR
local spec_path = vim.fn.stdpath 'config' .. '/lua/julia/plugins'

print(plugin_path)

---@class plugin.Spec
---@field name string
---@field init? function
---@field opts? table
---@field keys? table

if plugin_path == nil then
	vim.notify('NVIM_PLUGIN_DIR environment variable missing!', vim.log.levels.ERROR)
	return
end

---@param keymap table
local function apply_keymap(keymap)
	local function set_map(mode)
		vim.keymap.set(mode, keymap[1], keymap[2], {
			desc = keymap.desc or 'no description',
			noremap = true,
			silent = true,
		})
	end

	if type(keymap.mode) == 'table' then
		for _, mode in ipairs(keymap.mode) do
			set_map(mode)
		end
	else
		set_map(keymap.mode or 'n')
	end
end

---@param spec plugin.Spec
local function setup_plugin_spec(spec)
	if type(spec) ~= 'table' then
		vim.notify 'error, not a table'
		return
	end

	local name = spec.name
	if name == nil then
		vim.notify('missing name in spec: ' .. vim.inspect(spec), vim.log.levels.ERROR)
		return
	else
		name = name:gsub('.nvim', '')
		-- print(vim.inspect(spec))
	end

	print(name)
	require(name).setup(spec.opts or {})

	if spec.init then
		spec.init()
	end

	if spec.keys then
		for _, map in ipairs(spec.keys) do
			apply_keymap(map)
		end
	end
end

---@param specs plugin.Spec|plugin.Spec[]
---@return plugin.Spec[]
local function parse_specs(specs)
	local buff = {}
	for idx, c in pairs(specs) do
		if type(idx) == 'number' then
			table.insert(buff, c)
		else
			return { specs }
		end
	end
	return buff
end

---@param specs plugin.Spec[]
local function setup_specs(specs)
	for _, spec in ipairs(parse_specs(specs)) do
		setup_plugin_spec(spec)
	end
end

-- follow symlinks set up by nix and add derivations to runtime path
utils.iter_dir(plugin_path, function(name, type)
	local path = plugin_path .. '/' .. name
	if type == 'link' then
		path = vim.loop.fs_realpath(path) or path
	end

	print(path)
	vim.opt.rtp:prepend(path)
end)

utils.iter_dir(spec_path, function(filename, _)
	local name = filename:gsub('.lua', '')
	local module = require('julia.plugins.' .. name)
	setup_specs(module)
end)

setup_specs(require 'julia.plugins.theme')

-- require 'snacks.nvim'
