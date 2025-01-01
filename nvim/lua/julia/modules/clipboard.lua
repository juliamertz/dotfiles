
vim.api.nvim_create_autocmd('TextYankPost', {
	pattern = { 'man', 'help' },
	callback = function()
		vim.keymap.set('n', 'gd', '<C-]>', { buffer = true })
	end,
})

-- TextYankPost			Just after a |yank| or |deleting| command, but not
-- 				if the black hole register |quote_| is used nor
-- 				for |setreg()|. Pattern must be "*".
-- 				Sets these |v:event| keys:
-- 				    inclusive
-- 				    operator
-- 				    regcontents
-- 				    regname
-- 				    regtype
-- 				    visual
-- 				The `inclusive` flag combined with the |'[|
-- 				and |']| marks can be used to calculate the
-- 				precise region of the operation.
--
-- 				Non-recursive (event cannot trigger itself).
-- 				Cannot change the text. |textlock|
