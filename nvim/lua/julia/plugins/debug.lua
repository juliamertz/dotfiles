local utils = require 'utils'

return {
	'mfussenegger/nvim-dap',
	enabled = utils.enableForCat 'debug',
	dependencies = {
		'rcarriga/nvim-dap-ui',
		'nvim-neotest/nvim-nio',

		{ 'williamboman/mason.nvim', enabled = utils.lazyAdd(true, false) },
		{ 'jay-babu/mason-nvim-dap.nvim', enabled = utils.lazyAdd(true, false) },

		'leoluz/nvim-dap-go',
	},
	config = function()
		local dap = require 'dap'
		local dapui = require 'dapui'

		if not utils.isNixCats then
			require('mason-nvim-dap').setup {
				automatic_installation = true,
				handlers = {},
				ensure_installed = {
					'delve', -- golang
				},
			}
		end

		vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
		vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
		vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
		vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
		vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
		vim.keymap.set('n', '<leader>B', function()
			dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
		end, { desc = 'Debug: Set Breakpoint' })

		dapui.setup {
			icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
			controls = {
				icons = {
					pause = '⏸',
					play = '▶',
					step_into = '⏎',
					step_over = '⏭',
					step_out = '⏮',
					step_back = 'b',
					run_last = '▶▶',
					terminate = '⏹',
					disconnect = '⏏',
				},
			},
		}

		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

		dap.listeners.after.event_initialized['dapui_config'] = dapui.open
		dap.listeners.before.event_terminated['dapui_config'] = dapui.close
		dap.listeners.before.event_exited['dapui_config'] = dapui.close

		require('dap-go').setup {
			delve = {
				detached = vim.fn.has 'win32' == 0,
			},
		}
	end,
}

-- {
--   name = "Launch";
--   type = "codelldb";
--   request = "launch";
--   cwd = "$\{workspaceFolder}";
--   stopOnEntry = false;
--
--   program.__raw = ''
--     function()
--       local zig_out = vim.fn.getcwd() .. "/zig-out/bin/"
--       -- check if zig-out contains executable with name of project directory
--       local project_name = vim.fs.basename(vim.fn.getcwd())
--       if vim.fn.filereadable(zig_out .. project_name) == 1 then
--         return zig_out .. project_name
--       end
--
--       -- otherwise prompt for executable name
--       return vim.fn.input("Path to executable: ", zig_out, "file")
--     end
--   '';
--   args.__raw = ''
--     function()
--       local args_string = vim.fn.input('Arguments: ')
--       return vim.split(args_string, " ")
--     end
--   '';
-- }
