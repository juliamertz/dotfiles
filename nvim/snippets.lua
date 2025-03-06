local ls = require 'luasnip'
local fmt = require('luasnip.extras.fmt').fmt
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local s = ls.snippet

keymap({ 'i' }, '<C-K>', function()
	ls.expand()
end)

keymap({ 'i', 's' }, '<C-L>', function()
	ls.jump(1)
end)

keymap({ 'i', 's' }, '<C-J>', function()
	ls.jump(-1)
end)

keymap({ 'i', 's' }, '<C-E>', function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

-- snippet helper functions

---@param snippets table
---@param lang string|string[]
local function add_snippets(snippets, lang)
	local stack = {}
	for _, snippet in pairs(snippets) do
		table.insert(stack, snippet)
	end

	if type(lang) == 'table' then
		for _, l in pairs(lang) do
			ls.add_snippets(l, stack)
		end
		return
	else
		ls.add_snippets(lang, stack)
	end
end

local function same(index)
	return ls.function_node(function(args)
		return args[1]
	end, { index })
end

-- will replicate a given node index but capitalize the first letter
local function same_capitalized(index)
	return ls.function_node(function(args)
		local val = args[1][1]
		args[1][1] = val:sub(1, 1):upper() .. val:sub(2)

		return args[1]
	end, { index })
end

local require_var = function(args, _)
	local text = args[1][1] or ''
	text = text:gsub('-', '_')
	local split = vim.split(text, '.', { plain = true })

	local options = {}
	for len = 0, #split - 1 do
		table.insert(options, t(table.concat(vim.list_slice(split, #split - len, #split), '_')))
	end

	return ls.sn(nil, {
		c(1, options),
	})
end

local function make_if_let(trig)
	return s(
		{ trig = 'iflet' .. string.lower(trig) },
		fmt('if let ' .. trig .. '({}) = {} {{\n\t{}\n}}', {
			i(1),
			i(2),
			i(3),
		})
	)
end

ls.cleanup()
ls.setup {
	updateevents = 'TextChanged,TextChangedI',
	enable_autosnippets = true,
	history = true,
}

-- snippets

local lua_snippets = {
	req = s(
		{ trig = 'req' },
		fmt([[local {} = require("{}")]], {
			d(2, require_var, { 1 }),
			i(1),
		})
	),
	func = s(
		{ trig = 'func' },
		fmt([[function({})\n\t{}\nend]], {
			i(1, 'args'),
			i(0),
		})
	),
}

local react_snippets = {
	useeffect = s(
		{ trig = 'useeffect' },
		fmt(
			[[
    useEffect(() => {{
      {}
    }}, [{}])
  ]],
			{ i(1), i(2) }
		)
	),

	usetranslation = s(
		{ trig = 'usetrans' },
		fmt(
			[[
  const {{ t }} = useTranslation(["{}"])
  ]],
			{ i(1) }
		)
	),

	usestate = s(
		{ trig = 'usestate' },
		fmt(
			[[
    const [{}, set{}] = useState({})
  ]],
			{ i(1), same_capitalized(1), i(2) }
		)
	),

	export_default_function = s(
		{
			trig = 'export default function',
			snippetType = 'autosnippet',
		},
		fmt(
			[[
  export default function {}() {{
    return (
      <{}>{}</{}>
    )
  }}
  ]],
			{ i(1), i(2), i(3), same(2) }
		)
	),
}

local go_snippets = {
	if_err = s(
		{ trig = 'iferr' },
		fmt(
			[[
      if err != nil {{
        return {}
      }}
    ]],
			{ i(1) }
		)
	),
}

local rust_snippets = {
	derive = s(
		{ trig = 'derive' },
		fmt('#[derive(Debug, {})]', {
			i(0),
		})
	),
	if_let_some = make_if_let 'Some',
	if_let_ok = make_if_let 'Ok',
	if_let_err = make_if_let 'Err',
	match_option = s(
		{ trig = 'matchopt' },
		fmt(
			[[match {} {{
  Some({}) => {},
  None => {},
}}]],
			{
				i(1),
				i(2),
				i(3),
				i(4),
			}
		)
	),
	match_result = s(
		{ trig = 'matchres' },
		fmt(
			[[match {} {{
  Ok({}) => {},
  Err(err) => {},
}}]],
			{
				i(1),
				i(2),
				i(3),
				i(4),
			}
		)
	),
}

local zig_snippets = {
	import = s({ trig = 'import' }, fmt('const {} = @import("{}");', { i(1), i(2) })),
	struct = s(
		{ trig = 'struct' },
		fmt [[const {} = struct {
  };]]
	),
}

local html_snippets = {
	boilerplate = s(
		{ trig = '!' },
		fmt(
			[[
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <title>{}</title>
      <meta name="viewport" content="width=device-width,initial-scale=1" />
      <meta name="description" content="" />
      <link rel="icon" href="favicon.png">
    </head>
    <body>
      <div>{}</div>
    </body>
  </html>
  ]],
			{ i(1), i(2) }
		)
	),
}

local global_snippets = {
	shebang = s({ trig = '#!' }, fmt('#!/usr/bin/env {}\n\n{}', { i(1), i(2) })),
}

add_snippets(lua_snippets, 'lua')
add_snippets(react_snippets, 'typescriptreact')
add_snippets(go_snippets, 'go')
add_snippets(rust_snippets, 'rust')
add_snippets(zig_snippets, { 'zig' })
add_snippets(html_snippets, { 'html', 'htmldjango' })
add_snippets(global_snippets, 'all')
