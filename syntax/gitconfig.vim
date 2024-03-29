" Language:	git config file
" Maintainer:	Tim Pope <vimNOSPAM@tpope.org>
" Filenames:	gitconfig, .gitconfig, *.git/config

if exists("b:current_syntax")
  finish
en

syn case ignore
syn sync minlines=10

syn match   gitconfigComment	"[#;].*" contains=@Spell,@In_fancY
syn match   gitconfigSection	"\%(^\s*\)\@<=\[[a-z0-9.-]\+\]"
syn match   gitconfigSection	'\%(^\s*\)\@<=\[[a-z0-9.-]\+ \+\"\%([^\\"]\|\\.\)*"\]'
syn match   gitconfigVariable	"\%(^\s*\)\@<=\a[a-z0-9-]*\%(\s*\%([=#;]\|$\)\)\@=" nextgroup=gitconfigAssignment skipwhite
syn region  gitconfigAssignment
            \ matchgroup=gitconfigNone
            \ start=+=\s*+
            \ skip=+\\+
            \ end=+\s*$+
            \ contained
            \ contains=gitconfigBoolean,gitconfigNumber,gitConfigString,gitConfigEscape,gitConfigError,gitconfigComment
            \ keepend

syn keyword gitconfigBoolean true false yes no contained
syn match   gitconfigNumber  "\<\d\+\>" contained
syn region  gitconfigString  matchgroup=gitconfigDelim start=+"+ skip=+\\+ end=+"+ matchgroup=gitconfigError end=+[^\\"]\%#\@!$+ contained contains=gitconfigEscape,gitconfigEscapeError
syn match   gitconfigError  +\\.+	 contained
syn match   gitconfigEscape +\\[\\"ntb]+ contained
syn match   gitconfigEscape +\\$+	 contained

hi def link gitconfigComment		Comment
hi def link gitconfigSection		Keyword
hi def link gitconfigVariable		Identifier
hi def link gitconfigBoolean		Boolean
hi def link gitconfigNumber		Number
hi def link gitconfigString		String
hi def link gitconfigDelim		Delimiter
hi def link gitconfigEscape		Special
hi def link gitconfigError		Error

let b:current_syntax = "gitconfig"
