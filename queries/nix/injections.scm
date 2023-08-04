;; extends

; home.file.*.text
(binding
  attrpath: (_) @_path
  expression: (_
    (string_fragment) @injection.content
  )
  (#hmts-path? @_path "home" "file" ".*" "text")
  (#hmts-inject! @_path)
) @combined

; xdg.configFile.*.text
(binding
  attrpath: (_) @_path
  expression: (_
    (string_fragment) @injection.content
  )
  (#hmts-path? @_path "xdg" "configFile" ".*" "text")
  (#hmts-inject! @_path)
) @combined

; ''
; #! /bin/lang
; ''
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
  attrpath: (_) @_path (#hmts-path? @_path "programs" "fish" "((interactive|login)S|s)hellInit$")
  expression: (_ (string_fragment) @fish)
) @combined

(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "fish" "functions")
  expression: (attrset_expression
    (binding_set
      binding: (binding
        attrpath: (_)
        expression: (_ (string_fragment) @fish)
  )))
) @combined

; Bash
(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "bash" "(init|logout|profile|bashrc)Extra$")
  expression: (_ (string_fragment) @bash)
) @combined

; Zsh
(binding
  attrpath: (_) @_path
  ; eww
  (#hmts-path? @_path "programs" "bash" "(completionInit|envExtra|initExtra|initExtraBeforeCompInit|initExtraFirst|loginExtra|logoutExtra|profileExtra)$")
  expression: (_ (string_fragment) @bash)
) @combined

; Firefox
(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "firefox" "profiles" ".*" "userChrome")
  expression: (_ (string_fragment) @css)
) @combined
