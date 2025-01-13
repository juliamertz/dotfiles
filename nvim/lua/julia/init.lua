vim.g.mapleader = ' '

require 'julia.plugin'
require 'julia.set'
require 'julia.binds'

vim.filetype.add {
	pattern = {
		['.*/hypr/.*%.conf'] = 'hyprlang',
	},
}
