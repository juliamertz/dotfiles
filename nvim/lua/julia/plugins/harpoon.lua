local keymap = require('julia.utils').keymap

return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',
	config = function()
		local harpoon = require 'harpoon'
		harpoon:setup()

		keymap('n', '<m-h><m-m>', function() harpoon:list():add() end)
		keymap(
			'n',
			'<m-h><m-l>',
			function() harpoon.ui:toggle_quick_menu(harpoon:list()) end
		)

		-- Set <space>1..<space>5 be my shortcuts to moving to the files
		for _, idx in ipairs { 1, 2, 3, 4, 5 } do
		keymap(
				'n',
				string.format('<space>%d', idx),
				function() harpoon:list():select(idx) end
			)
		end
	end,
}
