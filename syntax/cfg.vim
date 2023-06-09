" Language:	Good old CFG files
" Maintainer:	Igor N. Prischepoff (igor@tyumbit.ru, pri_igor@mail.ru)
" Last change:	2012 Aug 11

"\ 我要用的其实是它?
"\ /home/wf/dotF/cfg/nvim/syntax/conf.vim

" quit when a syntax file was already loaded
if exists ("b:current_syntax")
    finish
en

" case off
syn case ignore
syn keyword cfgOnOff  ON OFF YES NO TRUE FALSE  contained
syn match UncPath "\\\\\p*" contained
"\ Dos Drive:\Path
syn match cfgDirectory "[a-zA-Z]:\\\p*" contained

"\ Parameters
syn match   cfgParams    ".\{0}="me=e-1 contains=cfgComment

"\ ... and their values (don't want to highlight '=' sign)
syn match   cfgValues    "=.*"hs=s+1 contains=cfgDirectory,UncPath,cfgComment,cfgString,cfgOnOff

" Sections
syn match cfgSection	    "\[.*\]"
syn match cfgSection	    "{.*}"

" String
syn match  cfgString	"\".*\"" contained
syn match  cfgString    "'.*'"   contained

" Comments (Everything before '#' or '//' or ';')
syn match  cfgComment	"#.*"
syn match  cfgComment	";.*"
syn match  cfgComment	"\/\/.*"

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi def link cfgOnOff     Label
hi def link cfgComment	Comment
hi def link cfgSection	Type
hi def link cfgString	String
hi def link cfgParams    Keyword
hi def link cfgValues    Constant
hi def link cfgDirectory Directory
hi def link UncPath      Directory


let b:current_syntax = "cfg"
