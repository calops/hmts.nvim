;; extends

; home.file.*.text
(binding
  attrpath: (_) @_path (#hmts-path? @_path "home" "file" ".*" "text")
  expression: (_ (string_fragment) @injection.content)
  (#hmts-inject! @_path)
  (#set! injection.combined)
)

; xdg.configFile.*.text
(binding
  attrpath: (_) @_path (#hmts-path? @_path "xdg" "configFile" ".*" "text")
  expression: (_ (string_fragment) @injection.content)
  (#hmts-inject! @_path)
  (#set! injection.combined)
)

; Strings with shebang expressions:
;   ''
;   #! /bin/lang
;   ''
(
  (indented_string_expression
    (string_fragment) @injection.language (#lua-match? @injection.language "^%s*#!")
  ) @injection.content
  (#gsub! @injection.language ".*#!.*env (%S+).*" "%1")
  (#gsub! @injection.language ".*#!%s*%S*/(%S+).*" "%1")
  (#set! injection.include-children)
  (#set! injection.combined)
)

; Explicit annotations in comments:
;   /* lang */ ''script''
; or:
;   # lang
;   ''script''
((comment) @injection.language
  .
  (_ (string_fragment) @injection.content)
  (#gsub! @injection.language "[/*#%s]" "")
  (#set! injection.combined)
)

; Fish
(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "fish" "((interactive|login)S|s)hellInit$")
  expression: (_ (string_fragment) @injection.content)
  (#set! injection.language "fish")
  (#set! injection.combined)
)

(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "fish" "(shellAliases|shellAbbrs|functions)" ".*" "body")
  expression: (_ (string_fragment) @injection.content)
  (#set! injection.language "fish")
  (#set! injection.combined)
)

(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "fish" "(shellAliases|shellAbbrs|functions)" ".*")
  expression: (_ (string_fragment) @injection.content)
  (#set! injection.language "fish")
  (#set! injection.combined)
)

; Bash
(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "bash" "(init|logout|profile|bashrc)Extra$")
  expression: (_ (string_fragment) @injection.content)
  (#set! injection.language "bash")
  (#set! injection.combined)
)

; Zsh
(binding
  attrpath: (_) @_path
  (#hmts-path? @_path "programs" "bash" "(completionInit|envExtra|initExtra|initExtraBeforeCompInit|initExtraFirst|loginExtra|logoutExtra|profileExtra)$")
  expression: (_ (string_fragment) @injection.content)
  (#set! injection.language "bash")
  (#set! injection.combined)
)

; Firefox
(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "firefox" "profiles" ".*" "userChrome")
  expression: (_ (string_fragment) @injection.content)
  (#set! injection.language "css")
  (#set! injection.combined)
)

; Wezterm
(binding
  attrpath: (_) @_path (#hmts-path? @_path "programs" "wezterm" "extraConfig")
  expression: (_ (string_fragment) @injection.content)
  (#set! injection.language "lua")
  (#set! injection.combined)
)
