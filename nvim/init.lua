local utils = require 'utils'
utils.setup { non_nix_value = true }

local plugins = nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }
local spec = { import = 'julia.plugins' }

require 'julia'
require('utils.lazyCat').setup(plugins, spec, {
	lockfile = utils.getlockfilepath(),
})
