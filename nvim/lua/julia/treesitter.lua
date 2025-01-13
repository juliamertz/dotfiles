local utils = require 'julia.utils'

local parser_path = vim.env.NVIM_PARSERPATH
print(parser_path)

utils.iter_dir(parser_path, function(name, type)
	local path = parser_path .. '/' .. name
	if type == 'link' then
		path = vim.loop.fs_realpath(path) or path
	end

	vim.opt.rtp:prepend(path)
end)

vim.api.nvim_create_autocmd('FileType', {
	callback = function(_)
		pcall(vim.treesitter.start)
	end,
})

