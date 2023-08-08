;; extends

; home.file.*.text
(binding
  attrpath: (_) @_path (#hmts-path? @_path "home" "file" ".*" "text")
  expression: (_
    (string_fragment) @injection.content
  )
  (#hmts-inject! @_path)
) @combined

; xdg.configFile.*.text
(binding
  attrpath: (_) @_path (#hmts-path? @_path "xdg" "configFile" ".*" "text")
  expression: (_
    (string_fragment) @injection.content
  )
  (#hmts-inject! @_path)
) @combined

; Strings with shebang expressions:
;   ''
;   #! /bin/lang
;   ''
(
  (indented_string_expression
    (string_fragment) @injection.language (#lua-match? @injection.language "^%s*#!")
    (_)*
  ) @injection.content
  (#gsub! @injection.language ".*#!.*env (%S+).*" "%1")
  (#gsub! @injection.language ".*#!%s*%S*/(%S+).*" "%1")
  (#set! injection.include-children)
) @combined

; Explicit annotations in comments:
;   /* lang */ ''script''
; or:
;   # lang
;   ''script''
((comment) @injection.language
  .
  (_ (string_fragment) @injection.content)
  (#gsub! @injection.language "[/*#%s]" "")
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
  (#hmts-path? @_path "programs" "bash" "(completionInit|envExtra|initExtra|initExtraBeforeCompInit|initExtraFirst|loginExtra|logoutExtra|profileExtra)$")
  expression: (_ (string_fragment) @bash)
) @combined

; Firefox
(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "firefox" "profiles" ".*" "userChrome")
  expression: (_ (string_fragment) @css)
) @combined

; Wezterm
(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "wezterm" "extraConfig")
  expression: (_ (string_fragment) @lua)
) @combined
