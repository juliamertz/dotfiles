vim.g.mapleader = ' '

require 'julia.lazy'
require 'julia.set'
require 'julia.binds'

vim.filetype.add {
	pattern = {
		['.*/hypr/.*%.conf'] = 'hyprlang',
	},
}
