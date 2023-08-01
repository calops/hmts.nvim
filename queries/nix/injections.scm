;; extends

(binding
  attrpath: (_) @_path (#match? @_path "((interactive|login)S|s)hellInit$")
  expression: [
		(string_expression (string_fragment) @fish)
		(indented_string_expression (string_fragment) @fish)
	]
  (#nix-path? @_path "programs" "fish")
) @combined

(binding
  attrpath: (_) @_path (#match? @_path "functions$")
  expression: (attrset_expression
                (binding_set
                  binding: (binding
                             attrpath: (_)
                             expression: [
                                          (string_expression (string_fragment) @fish)
                                          (indented_string_expression (string_fragment) @fish)
                                          ]
                             )
                )
              )
  (#nix-path? @_path "programs" "fish")
) @combined
