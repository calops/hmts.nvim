;; extends

; Generic
(binding
  attrpath: (_) @_path
  expression: (_
    (string_fragment) @injection.content
  )
  (#hmts-path? @_path "home" "file" ".*" "text")
  (#hmts-inject! @_path)
) @combined

(binding
  attrpath: (_) @_path
  expression: (_
    (string_fragment) @injection.content
  )
  (#hmts-path? @_path "xdg" "configFile" ".*" "text")
  (#hmts-inject! @_path)
) @combined

(
  (indented_string_expression
    (string_fragment) @_lang (#lua-match? @_lang "^%s*#!.*/.") ; use lua regex for consistency with the next line
    (_)*
  ) @injection.content
  (#gsub! @_lang ".*#!%s*%S*/(%S+).*" "%1")
  (#inject-language! @_lang)
  (#offset! @injection.content 0 2 0 -2)
) @combined

; Fish
(binding
  attrpath: (_) @_path (#match? @_path "((interactive|login)S|s)hellInit$")
  expression: (_ (string_fragment) @fish)
  ; TODO: find a way to have proper regex support here
  (#hmts-path? @_path "programs" "fish" ".*")
) @combined

(binding
  attrpath: (_) @_path
  expression: (attrset_expression
    (binding_set
      binding: (binding
        attrpath: (_)
        expression: (_ (string_fragment) @fish)
  )))
  (#hmts-path? @_path "programs" "fish" "functions")
) @combined

; Bash
(binding
  attrpath: (_) @_path (#match? @_path "(init|logout|profile|bashrc)Extra$")
  expression: (_ (string_fragment) @bash)
  ; TODO: find a way to have proper regex support here
  (#hmts-path? @_path "programs" "bash" ".*")
) @combined

; Zsh
(binding
  ; eww
  attrpath: (_) @_path (#match? @_path "(completionInit|envExtra|initExtra|initExtraBeforeCompInit|initExtraFirst|loginExtra|logoutExtra|profileExtra)$")
  expression: (_ (string_fragment) @bash)
  ; TODO: find a way to have proper regex support here
  (#hmts-path? @_path "programs" "bash" ".*")
) @combined

; Firefox
(binding
  attrpath: (_) @_path
  expression: (_ (string_fragment) @css)
  (#hmts-path? @_path "programs" "firefox" "profiles" ".*" "userChrome")
) @combined
