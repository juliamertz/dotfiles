local utils = require 'utils'

return {
	'nvim-treesitter/nvim-treesitter',
	build = utils.lazyAdd ':TSUpdate',
	branch = 'main',
	lazy = false,

	config = function(_, opts)
		local function treesitter_try_attach(bufnr, language)
			if not vim.treesitter.language.add(language) then
				return false
			end

			vim.treesitter.start(bufnr, language)

			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

			return true
		end

		local treesitter = require 'nvim-treesitter'
		local installable_parsers = treesitter.get_available()

		vim.api.nvim_create_autocmd('FileType', {
			callback = function(args)
				local buf, filetype = args.buf, args.match
				local language = vim.treesitter.language.get_lang(filetype)
				if not language then
					return
				end

				if not treesitter_try_attach(buf, language) then
					if vim.tbl_contains(installable_parsers, language) then
						treesitter.install(language):await(function()
							treesitter_try_attach(buf, language)
						end)
					end
				end
			end,
		})
	end,
}
