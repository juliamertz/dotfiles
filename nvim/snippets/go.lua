return {
	s(
		'iferr',
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
