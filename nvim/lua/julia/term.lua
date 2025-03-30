--- @param type? "left" | "right" | "above" | "below".
local function term_split(type)
	if type == nil or type == '' then
		type = 'below'
	end

	local window = vim.api.nvim_open_win(0, true, {
		split = type,
		win = 0,
	})

	vim.api.nvim_win_call(window, function()
		vim.cmd [[
      terminal
      startinsert
    ]]
	end)
end

-- disable line numbers in terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
	group = vim.api.nvim_create_augroup('termopen', { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

-- create user command to open new split
vim.api.nvim_create_user_command('TermSplit', function(data)
	term_split(data.args)
end, {
	nargs = '?',
	complete = function(ArgLead, CmdLine, CursorPos)
		local options = { 'left', 'right', 'above', 'below' }
		local matches = {}

		for _, option in ipairs(options) do
			if option:match('^' .. ArgLead) then
				table.insert(matches, option)
			end
		end

		return matches
	end,
	desc = 'Open terminal split',
})

-- set some keymaps
local opts = { noremap = true, silent = true }
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', opts)
vim.keymap.set('n', '<leader>vt', function()
	term_split 'right'
end, opts)
vim.keymap.set('n', '<leader>tt', function()
	term_split 'below'
end, opts)
