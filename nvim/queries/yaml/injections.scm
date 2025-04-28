; extends

; highlights for kubernetes jobs
(block_mapping_pair
  key: (flow_node) @_command
  (#any-of? @_command "command")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "bash")))


; single line list item
(block_mapping_pair
  key: (flow_node) @_command
  (#any-of? @_command "command")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content)
          (#set! injection.language "bash"))))))

; multiline block list item
(block_mapping_pair key: (flow_node) @_command
  (#any-of? @_command "command")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node 
          (block_scalar) @injection.content)
        (#set! injection.language "bash")))))
