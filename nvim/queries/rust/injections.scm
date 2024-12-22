; extends

; Injects SQL highlighting into `sqlx:query` macro invocations
(field_expression(_
  (scoped_identifier 
    path: (identifier) @path (#eq? @path "sqlx")
    name: (identifier) @name (#match? @name "query.*")
  )
  (_(_
    (string_content) @injection.content)
    (#set! injection.language "sql")
  ))
)

; Injects Javascript highlighting into `Script()` structs for maud
(call_expression
  function: (identifier) @name (#eq? @name "Script")
  arguments: (arguments (raw_string_literal 
    (string_content) @injection.content)
    (#set! injection.language "javascript")
  )
)

