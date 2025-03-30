local utils = require 'utils'

return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',
	name = 'harpoon2',
	dependencies = { 'nvim-lua/plenary.nvim' },

	enabled = utils.enableForCat 'harpoon',

	init = function()
		local keymap = utils.keymap
		local harpoon = require 'harpoon'

		harpoon:setup()

		keymap('n', '<space>aa', function()
			harpoon:list():add()
		end)
		keymap('n', '<space>op', function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		for _, idx in ipairs { 1, 2, 3, 4, 5 } do
			keymap('n', string.format('<space>%d', idx), function()
				harpoon:list():select(idx)
			end)
		end
	end,
}
