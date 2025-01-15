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

return {
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
