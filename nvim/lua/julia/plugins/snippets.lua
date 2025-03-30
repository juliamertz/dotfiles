return {
	'L3MON4D3/LuaSnip',
	name = 'luasnip',
	build = require('utils').lazyAdd((function()
		return 'make install_jsregexp'
	end)()),

	init = function()
		local snippets_path = vim.fn.stdpath 'config' .. '/snippets'
		require('luasnip.loaders.from_lua').load { paths = snippets_path }
	end,
}
