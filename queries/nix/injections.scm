;; extends

(binding
  attrpath: (_) @_path (#match? @_path "interactiveShellInit$")
  expression: [
		(string_expression (string_fragment) @fish)
		(indented_string_expression (string_fragment) @fish)
	]
  (#nix-path? @_path "programs" "fish")
) @combined
