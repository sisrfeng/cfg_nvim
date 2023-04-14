"\ 另有 ./config.vim

if exists("b:current_syntax")
  finish
endif

syn keyword     confTodo        contained TODO FIXME XXX
" Avoid matching "text#text", used in /etc/disktab and /etc/gettytab
syn match       confComment     "^#.*" contains=confTodo,@Spell
syn match       confComment     "\s#.*"ms=s+1 contains=confTodo,@Spell
syn region      confString      start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline
syn region      confString      start=+'+ skip=+\\\\\|\\'+ end=+'+ oneline

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link confComment Comment
hi def link confTodo    Todo
hi def link confString  String

let b:current_syntax = "conf"

