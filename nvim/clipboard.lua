-- Small implementation of what yanky.nvim does
-- Currently the clipboard is completely broken and throws weird errors when running in tmux over ssh
-- The issue for this has gone without replies for a while now so this will have to do
-- https://github.com/gbprod/yanky.nvim/issues/204

-- FIX: multiline yanks put with an extra newline at the bottom
-- TODO: sync entries with filesystem with some sort of unique id so we can merge
-- TODO: delete or circumvent creating a new history entry on cycle

vim.keymap.set('n', '<leader>xx', ':so %<CR>')

local function map(tbl, f)
	local t = {}
	local i = 0
	for k, v in pairs(tbl) do
		i = i + 1
		t[k] = f(v, i)
	end
	return t
end

function string:trim()
	return self:match '^%s*(.-)%s*$'
end

function string:split(delimiter)
	local result = {}
	local from = 1
	local delim_from, delim_to = string.find(self, delimiter, from)
	while delim_from do
		table.insert(result, string.sub(self, from, delim_from - 1))
		from = delim_to + 1
		delim_from, delim_to = string.find(self, delimiter, from)
	end
	table.insert(result, string.sub(self, from))
	return result
end

---@param lines string[]
---@param delimiter string
---@return string
local function string_join(lines, delimiter)
	local result = ''
	for _, line in ipairs(lines) do
		result = result + delimiter + line
	end
	return result
end

---@param msg string
---@param expected any
---@param actual any
local function assert(msg, expected, actual)
	if not vim.deep_equal(expected, actual) then
		local message = string.format(
			'Assertion failed: %s, expected: %s, actual: %s',
			msg,
			vim.inspect(expected),
			vim.inspect(actual)
		)
		vim.notify(message, vim.log.levels.ERROR)
	end
end

---@param msg string
---@param value any?
local function dbg(msg, value)
	local level = vim.log.levels.DEBUG
	if value == nil then
		vim.notify(msg, level)
	else
		vim.notify(msg .. ': ' .. vim.inspect(value), level)
	end
end

---@alias Pos [integer, integer] -- (row, column)

--- Count newlines and chars in last row
---@param lines string[]
---@return Pos
local function calculate_position(lines)
	local rows = #lines

	if rows == 0 then
		return { 0, 0 }
	end

	local cols = #lines[#lines]

	return { rows, cols }
end

---@class Placement
---@field buffer integer -- buffer handle or identifier where placement has been put
---@field offset integer -- selected entry offset, defaults to 0 (the latest entry)
---@field _start Pos
---@field _end Pos
local Placement = {}

---@param entry RingEntry -- Ring entry that will be placed
---@param position Pos? -- Position where placement should start, defaults to the result of nvim_win_get_cursor()
---@return Placement
function Placement:new(entry, position)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	self.offset = 0
	self.buffer = vim.api.nvim_get_current_buf()

	local start_row, start_col = unpack(position or vim.api.nvim_win_get_cursor(0))
	local content_rows, content_cols = unpack(calculate_position(entry.content))
	local end_row, end_col = start_row + content_rows, start_col + content_cols -- TODO: set start_col to zero if put method is multline ykyk

	self._start = { start_row, start_col }
	self._end = { end_row, end_col }

	return o
end

---@param direction "next" | "previous"
function Placement:cycle(ring, direction)
	if direction == 'next' then
		if self.offset == 0 then
			vim.notify 'Already at latest yank entry!'
			return
		end
		self.offset = self.offset - 1
	elseif direction == 'previous' then
		if self.offset == #ring.entries - 1 then
			vim.notify 'Already at oldest yank entry!'
			return
		end
		self.offset = self.offset + 1
	else
		vim.notify('cycle called with invalid direction: ' .. direction, vim.log.levels.ERROR)
	end

	local index = #ring.entries - self.offset
	local entry = ring.entries[index]
	self:update(entry)
end

--- Update placements end position to match the contents length
---@param content string[]
function Placement:update_end_by_content(content)
	local rows, cols = unpack(calculate_position(content))
	local start_row, _ = unpack(self._start)
	local end_row, end_col = start_row + rows, cols
	self._end = { end_row, end_col }
end

---@param entry RingEntry
function Placement:update(entry)
	local start_row, start_col = unpack(self._start)
	local end_row, end_col = unpack(self._end)

	-- TODO: i don't like this -1 -2 business
	vim.api.nvim_buf_set_text(self.buffer, start_row - 1, start_col, end_row - 2, end_col, entry.content)
	self:update_end_by_content(entry.content)
end

-- Placement tests

local test_content = { 'hello world!' }
local test_placement = Placement:new({ content = test_content, yanked_at = '' }, { 0, 0 })

assert('Placement creation start pos', test_placement._start, { 0, 0 })
assert('Placement creation end position', test_placement._end, { 1, 12 })

test_placement:update_end_by_content { 'hi' }
assert('Placement creation end position', test_placement._end, { 1, 2 })

---@alias YankMode 'l' | 'c' -- linewise or charwise

---@class RingEntry
---@field content string[]
---@field mode YankMode
---@field yanked_at string

---@class RingOptions
---@field storage_path string
---@field write_on_push boolean
---@field filter_repeats boolean
local default_opts = {
	storage_path = vim.fn.stdpath 'data' .. '/yank-ring.json',
	write_on_push = true,
	filter_repeats = true,
}

---@class Ring
---@field opts RingOptions
---@field active_placement Placement?
---@field entries RingEntry[]
local Ring = {
	opts = default_opts,
	active_placement = nil,
	entries = {},
}

---@return Ring
function Ring:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Ring:next()
	self.active_placement:cycle(self, 'next')
end

function Ring:previous()
	self.active_placement:cycle(self, 'previous')
end

---@param mode 'r' | 'w'
---@param quiet boolean?
---@return file*?
function Ring:open_fs(mode, quiet)
	local filepath = self.opts.storage_path
	local file = io.open(filepath, mode)
	if not file then
		if not quiet then
			vim.notify('Failed to open file for mode ' .. mode .. ': ' .. filepath, vim.log.levels.ERROR)
		end
		return nil
	end
	return file
end

---@return RingEntry[]?
function Ring:read_fs()
	local file = self:open_fs('r', true)
	if not file then
		self:write_fs {}
		return {}
	end

	local content = file:read()
	return vim.fn.json_decode(content)
end

-- TODO: async write
--
---@param entries RingEntry[]
---@return boolean
function Ring:write_fs(entries)
	local file = self:open_fs 'w'
	local content = vim.fn.json_encode(entries)

	local ok = pcall(function()
		file:write(content)
	end)

	file:close()

	if not ok then
		print 'Failed to write to file in Ring:write_fs'
		return false
	end
	return true
end

function Ring:sync_fs()
	local entries = self:read_fs()
	if entries == nil then
		dbg 'unable to read entries from fs got nil'
		return
	end
	self.entries = entries
end

---@param value string[]
function Ring:push(value)
	if #self.entries > 0 then
		local last = self.entries[#self.entries]
		if vim.deep_equal(last.content, value) then
			-- dbg 'skipping repeat yank'
			return
		end
	end

	table.insert(self.entries, {
		content = value,
		yanked_at = vim.fn.strftime '%H:%M:%S',
	})

	-- TODO: placement should be invalidated on any action other than put
	self.active_placement = nil

	if self.opts.write_on_push then
		self:write_fs(self.entries)
	end
end

---@param after boolean
---@param entry_offset integer? -- defaults to 0
---@return Placement
function Ring:new_placement(after, entry_offset)
	local index = #self.entries - (entry_offset or 0)
	local entry = self.entries[index]
	local placement = Placement:new(entry)

	local mode = 'c' -- charwise by default
	-- TODO: linewise placements mess up replace
	-- if #entry.content > 1 then
	--   mode = 'l' -- linewise
	-- end

	vim.api.nvim_put(
		entry.content, -- todo store content as lines
		mode,
		after, -- If true insert after cursor (like p), or before (like P).
		false -- If true place cursor at end of inserted text.
	)

	return placement
end

function Ring:fzf_lua()
	local fzf_lua = require 'fzf-lua'
	local builtin = require 'fzf-lua.previewer.builtin'

	local RingPreviewer = builtin.base:extend()
	function RingPreviewer:new(o, opts, fzf_win)
		RingPreviewer.super.new(self, o, opts, fzf_win)
		setmetatable(self, RingPreviewer)
		return self
	end

	function RingPreviewer:populate_preview_buf(entry_str)
		local tmpbuf = self:get_tmp_buffer()
		vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, {
			string.format('SELECTED FILE: %s', entry_str),
		})
		self:set_preview_buf(tmpbuf)
	end

	function RingPreviewer:gen_winopts()
		return vim.tbl_extend('force', self.winopts, {
			wrap = false,
			number = true,
		})
	end

	local entries = map(self.entries, function(entry)
		return entry.content[1]:trim()
	end)
	fzf_lua.fzf_exec(entries, {
		previewer = RingPreviewer,
		prompt = 'Select entry > ',
	})
end

local ring = Ring:new()
ring:sync_fs()

vim.keymap.set('n', '<leader>pp', function()
	ring:fzf_lua()
end)

vim.keymap.set('n', 'p', function()
	ring.active_placement = ring:new_placement(true)
end)
vim.keymap.set('n', 'P', function()
	ring.active_placement = ring:new_placement(false)
end)
vim.keymap.set('n', '<C-n>', function()
	ring:next()
end)
vim.keymap.set('n', '<C-p>', function()
	ring:previous()
end)

local group = vim.api.nvim_create_augroup('yankring_group', {})
vim.api.nvim_create_autocmd('TextYankPost', {
	group = group,
	desc = 'Push yanked content to yank ring',
	pattern = '*',
	callback = function()
		---@type string
		local reg_content = vim.fn.getreg(0)
		if vim.v.event.visual then
			dbg 'visual copy'
		end
		ring:push(reg_content:split '\n')
	end,
})
