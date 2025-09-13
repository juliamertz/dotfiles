return {
	{
		'saghen/blink.cmp',

		version = '1.*',

		opts_extend = { 'sources.default' },

		opts = {
			keymap = {
				preset = 'none',

				['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<C-e>'] = { 'cancel', 'fallback' },
				['<C-y>'] = { 'select_and_accept', 'fallback' },

				['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
				['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

				['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
				['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

				['<C-l>'] = { 'snippet_forward', 'fallback' },
				['<C-j>'] = { 'snippet_backward', 'fallback' },

				['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
			},

			appearance = {
				nerd_font_variant = 'mono',
			},

			completion = {
				documentation = { auto_show = true },
			},

			sources = {
				default = {
					'lsp',
					'path',
					'snippets',
					'buffer',
				},
			},

			fuzzy = { implementation = 'prefer_rust' },
		},
	},
}
