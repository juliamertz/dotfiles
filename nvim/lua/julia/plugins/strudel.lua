local utils = require 'utils'

return {
	'gruvw/strudel.nvim',
	enabled = utils.enableForCat 'strudel',
	build = utils.lazyAdd 'npm ci',

	config = function()
		local browser = vim.env.PUPPETEER_EXECUTABLE_PATH
		-- ew
		if not browser and vim.fn.has 'mac' == 1 then
			browser = '/Applications/Brave Browser.app/Contents/MacOS/Brave Browser'
		end

		require('strudel').setup {
			browser_exec_path = browser,
		}

    vim.keymap.set("n", "<leader>su",function ()
      vim.cmd 'write'
      vim.cmd 'StrudelUpdate'
    end)
	end,
}
