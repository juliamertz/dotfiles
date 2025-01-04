local M = {}

---@class clip.Entry
---@field project_dir string
---@field file_path string
---@field content string

M.hist_dir = vim.fn.stdpath 'cache' .. '/clip'
M.hist_path = M.hist_dir .. '/history.json'

---@return any|nil
M.create_histfile = function()
	vim.system { 'mkdir', '-p', M.hist_dir }
	local ok, err = pcall(vim.fn.writefile, { '[]' }, M.hist_path)
	if ok then
		return
	else
		return err
	end
end

---@param content string
---@return string|nil
M.write_histfile = function(content)
	vim.system { 'mkdir', '-p', M.hist_dir }
	local ok, err = pcall(vim.fn.writefile, { content }, M.hist_path)

	if ok then
    return
	else
    return err
	end
end

---@return clip.Entry[]|nil
M.read_clipboard_history = function()
	local file = io.open(M.hist_path, 'r')
	if file == nil then
		file = M.create_histfile()
		if file == nil then
			return
		end
	end

	local contents = file:read '*a'
	file:close()
	return vim.fn.json_decode(contents)
end

---@param entry clip.Entry
M.insert_clipboard_entry = function(entry)
	local hist = M.read_clipboard_history()
	if hist == nil then
		vim.notify 'something went wrong'
		return
	end
	table.insert(hist, entry)
	M.write_histfile(vim.fn.json_encode(hist))
end

---@param entry clip.Entry
M.put_entry = function (entry)
  vim.api.nvim_put({entry.content}, 'b', true, true)
end

M.telescope_picker = function()
	local pickers = require 'telescope.pickers'
	local finders = require 'telescope.finders'
	local conf = require('telescope.config').values
	local actions = require 'telescope.actions'
	local action_state = require 'telescope.actions.state'

	local hist = M.read_clipboard_history()

	local opts = {
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
        vim.notify('selection: ' .. vim.inspect(selection))
        local entry = hist[selection.index]
        M.put_entry(entry)
				-- callback(selection[1])
			end)
			return true
		end,
	}

	local results = vim.tbl_map(function(entry)
		return vim.trim(entry.content):gsub('\n','')
	end, hist)

	pickers
		.new(opts, {
			prompt_title = 'Dependency',
			finder = finders.new_table {
				results = results,
			},
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('ClipGroup', { clear = true }),
	callback = function()
		local event = vim.v.event
		if event and event.regcontents then
			---@type clip.Entry
			local entry = {
				project_dir = vim.uv.cwd(),
				file_path = vim.fn.expand '%:p',
				content = table.concat(event.regcontents, '\n'),
			}
			M.insert_clipboard_entry(entry)
		end
	end,
})

vim.keymap.set('n', '<leader>xx', '<cmd>:so %<CR>')
vim.keymap.set('n', '<leader>pp', function()
	M.telescope_picker()
end)

