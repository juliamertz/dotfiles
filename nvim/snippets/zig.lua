return {
	s('import', fmt('const {} = @import("{}");', { i(1), i(2) })),
	s(
		'struct',
		fmt(
			[[const {} = struct {{
  {}
}};]],
			{ i(1), i(2) }
		)
	),
}
