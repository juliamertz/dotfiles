return {
	{
		'saghen/blink.cmp',

		version = '1.*',
		opts = {
			keymap = {
				preset = 'default',
				-- ['<C-space>'] = {
				-- 	'show',
				-- 	'show_documentation',
				-- 	'hide_documentation',
				-- },
				-- ['<C-e>'] = { 'hide' },
				-- ['<C-y>'] = { 'select_and_accept' },
				-- ['<C-p>'] = {
				-- 	'select_prev',
				-- 	'fallback',
				-- },
				-- ['<C-n>'] = {
				-- 	'select_next',
				-- 	'fallback',
				-- },
				-- ['<C-b>'] = {
				-- 	'scroll_documentation_up',
				-- 	'fallback',
				-- },
				-- ['<C-f>'] = {
				-- 	'scroll_documentation_down',
				-- 	'fallback',
				-- },
			},

			appearance = {
				nerd_font_variant = 'mono',
			},

			completion = {
				documentation = {
					auto_show = true,
				},
			},

			snippets = { preset = 'luasnip' },

			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},

			fuzzy = { implementation = 'prefer_rust_with_warning' },
		},
	},
}
