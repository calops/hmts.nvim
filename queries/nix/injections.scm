;; extends

; Generic
(binding
  attrpath: (_) @_path (#match? @_path "text$")
  expression: (_
    (string_fragment) @injection.content
  )
  (#hmts-path? @_path "xdg" "configFile" ".*" "text")
  (#hmts-inject! @_path)
) @combined

; Fish
(binding
  attrpath: (_) @_path (#match? @_path "((interactive|login)S|s)hellInit$")
  expression: (_ (string_fragment) @fish)
	
  ; I would prefer to have an accurate pattern here but lua regex are so awful, it's not possible
  (#hmts-path? @_path "programs" "fish" ".*")
) @combined

(binding
  attrpath: (_) @_path (#match? @_path "functions$")
  expression: (attrset_expression
    (binding_set
      binding: (binding
        attrpath: (_)
        expression: (_ (string_fragment) @fish)
  )))
  (#hmts-path? @_path "programs" "fish" "functions")
) @combined

; Firefox
(binding
  attrpath: (_) @_path (#match? @_path "userChrome$")
  expression: (_ (string_fragment) @css)
  (#hmts-path? @_path "programs" "firefox" "profiles" ".*" "userChrome")
) @combined
