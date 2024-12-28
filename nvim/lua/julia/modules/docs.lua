vim.keymap.set('n', '<leader>xx', '<cmd>:so %<CR>')

local M = {}

M.open_url = function(url)
	local success = false
	for _, opener in ipairs { 'xdg-open', 'open' } do
		if vim.fn.executable(opener) == 1 then
			local cmd = vim.system({ opener, url }):wait()
			if cmd.code == 0 then
				success = true
				break
			end
		end
	end

	if success == false then
		vim.notify('Failed to open: ' .. url, vim.log.levels.ERROR)
	end
end

---@param resolver docs.Resolver
---@param deps string[]
---@param callback fun(url: string)
M.telescope_picker = function(resolver, deps, callback)
	local pickers = require 'telescope.pickers'
	local finders = require 'telescope.finders'
	local conf = require('telescope.config').values
	local actions = require 'telescope.actions'
	local action_state = require 'telescope.actions.state'

	local opts = {
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				local url = resolver.get_url(selection[1])
				callback(url)
			end)
			return true
		end,
	}

	pickers
		.new(opts, {
			prompt_title = 'Dependency',
			finder = finders.new_table { results = deps },
			sorter = conf.generic_sorter {},
		})
		:find()
end

--- Resolves dependencies for a certain progamming language
--- in the current project repository
---@class docs.Resolver
---@field filename string: Filename of dependency config file
---@field parse fun(path: string): string[]|nil
---@field get_url fun(dep: string, version: string|nil): string

---@type docs.Resolver
local go_resolver = {
	filename = 'go.mod',
	get_url = function(dep, version)
		return ''
	end,
	parse = function(path)
		local deps = {}
		local file = io.open(path, 'r')
		if file then
			for line in file:lines() do
				print(line) -- Process each line
			end
			file:close() -- Don't forget to close the file after reading
		else
			print 'Failed to open file'
		end
	end,
}

---@type docs.Resolver
local rust_resolver = {
	filename = 'Cargo.toml',

	parse = function(path)
		if vim.fn.executable 'dasel' ~= 1 then
			vim.notify('dasel is not in your path!', vim.log.levels.ERROR)
			return
		end

		local jq_filter = [[
      . | to_entries
        | map (if (.value | type == "object") and (.value.package) then .value.package else .key end)
        | .[]
    ]]
		-- transform dependencies to json and get package field or key name
		local command = "dasel .dependencies -f Cargo.toml -w json | jq '" .. jq_filter .. "'"

		-- parse dependency names
		local cmd = vim.system({
			'sh',
			'-c',
			command,
		}, { text = true }):wait()

		if cmd.code ~= 0 then
			vim.notify(
				'error returned by dasel while parsing ' .. path .. ': ' .. cmd.stderr, --
				vim.log.levels.ERROR
			)
			return
		end

		-- collect and clean names
		local dependencies = {}
		for dep in string.gmatch(cmd.stdout, '%S+') do
			local name = dep:gsub('"', '', 2)
			table.insert(dependencies, name)
		end

		return dependencies
	end,

	get_url = function(name, version)
		local tag = version or 'latest'
		return 'https://docs.rs/' .. name .. '/' .. tag .. '/' .. name
	end,
}

---@type docs.Resolver[]
M.resolvers = { rust_resolver, go_resolver, }

---@param path string|nil
---@return docs.Resolver|nil
M.get_resolver = function(path)
	local files = vim.fn.readdir(path or vim.uv.cwd())
	for _, file in ipairs(files) do
		for _, resolver in ipairs(M.resolvers) do
			if resolver.filename == file then
				print('found a resolver for ' .. resolver.filename)
				return resolver
			end
		end
	end
end

M.open_deps = function()
	local resolver = M.get_resolver()
	if resolver ~= nil then
		local path = vim.uv.cwd() .. '/' .. resolver.filename
		local deps = resolver.parse(path)

		if deps == nil then
			vim.notify('No dependencies found in current directory', vim.log.levels.WARN)
			return
		end

		M.telescope_picker(resolver, deps, function(url)
			M.open_url(url)
		end)
	else
		vim.notify('No resolver matched in this directory', vim.log.levels.WARN)
	end
end

return M
