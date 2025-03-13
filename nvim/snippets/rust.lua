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
	s(
		'derive',
		fmt('#[derive(Debug, {})]', {
			i(0),
		})
	),
	if_let_some = make_if_let 'Some',
	if_let_ok = make_if_let 'Ok',
	if_let_err = make_if_let 'Err',
	s(
		'matchopt',
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
	s(
		'matchres',
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
