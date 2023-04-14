" 来自 /home/wf/d/leo_tools/coc/extensions/node_modules/coc-snippets/syntax/snippets.vim

" Syntax highlighting for snippet files (used for UltiSnips.vim)
" Revision: 26/03/11 19:53:33


if exists("b:current_syntax")  | finish  | en

"\ 我主要用snipmate
if !exists("b:ultisnips_override_snipmate")
    if  expand("%:p:h") =~ "snippets"   &&
     \ search("^endsnippet", "nw") == 0
            " It's in a directory called snippets/
            " and there's no endsnippet keyword  anywhere in the file.
            "\ this appears to be a snipmate file

        source  <sfile>:h/sm_snippets.vim  "\ sm_snippets.vim会调用本文件下面的. (因为有 let b:ultisnips_override_snipmate = 1)
        "\ echo  '用syntax/sm_snippets.vim 而非syntax/snippets.vim'
        finish
    en
en

" Embedded Syntaxes

try
     syn    include @Python syntax/python.vim
     unlet b:current_syntax

     syn    include @Viml syntax/vim.vim
     unlet b:current_syntax

     syn    include @Shell syntax/sh.vim
     unlet b:current_syntax
catch /E403/
     " Ignore errors about syntax files that can't be loaded more than once
endtry

" Syntax definitions {{{1

" Comments {{{2
    syn match snippetsComment "^#.*"    contains=snippetsTODO,snippetsDeli,In_fancY  display
    syn match snippetsDeli    "^# "     contained  containedin=snippetsComment conceal
    syn keyword snippetsTODO contained display FIXME NOTE NOTES TODO XXX

" Errors {{{2

syn match snippetsLeadingSpaces "^\t* \+" contained

" Extends {{{2

syn match snippetsExtends "^extends\%(\s.*\|$\)" contains=snippetsExtendsKeyword display
syn match snippetsExtendsKeyword "^extends" contained display

" Definitions {{{2

" snippet {{{3

syn region snippetsSnippet start="^snippet\_s" end="^endsnippet\s*$" contains=snippetsSnippetHeader fold keepend
syn match snippetsSnippetHeader "^.*$" nextgroup=snippetsSnippetBody,snippetsSnippetFooter skipnl contained contains=snippetsSnippetHeaderKeyword
syn match snippetsSnippetHeaderKeyword "^snippet" contained nextgroup=snippetsSnippetTrigger skipwhite
syn region snippetsSnippetBody start="\_." end="^\zeendsnippet\s*$" contained nextgroup=snippetsSnippetFooter contains=snippetsLeadingSpaces,@snippetsTokens
syn match snippetsSnippetFooter "^endsnippet.*" contained contains=snippetsSnippetFooterKeyword
syn match snippetsSnippetFooterKeyword "^endsnippet" contained

"\ snippetsSnippetTrigger要定义几遍的原因(双引号太多, 写在vim文件里很乱):
"\ /home/wf/PL/help_me/doc/snippets总结.txt
    syn match snippetsSnippetTrigger
            \ @\S\+@
            \ contained
            \ nextgroup=snippetsSnippetDocString,snippetsSnippetTriggerInvalid
            \ skipwhite

    syn match snippetsSnippetTrigger
            \ ,".\{-}"\ze\%(\s\+"\%(\s*\S\)\@=[^"]*\%("\s\+[^"[:space:]]\+\|"\)\=\)\=\s*$,
            \ contained
            \ nextgroup=snippetsSnippetDocString
            \ skipwhite

    syn match snippetsSnippetTrigger
            \ ,\%(\(\S\).\{-}\1\|\S\+\)\ze\%(\s\+"[^"]*\%("\s\+\%("[^"]\+"\s\+[^"[:space:]]*e[^"[:space:]]*\)\|"\)\=\)\=\s*$,
            \ contained
            \ nextgroup=snippetsSnippetDocContextString
            \ skipwhite

    syn match snippetsSnippetTrigger
        \ ,\([^"[:space:]]\).\{-}\1\%(\s*$\)\@!\ze\%(\s\+"[^"]*\%("\s\+\%("[^"]\+"\s\+[^"[:space:]]*e[^"[:space:]]*\|[^"[:space:]]\+\)\|"\)\=\)\=\s*$,
        \ contained
        \ nextgroup=snippetsSnippetDocString
        \ skipwhite

syn match snippetsSnippetTriggerInvalid
    \ ,\S\@=.\{-}\S\ze\%(\s\+"[^"]*\%("\s\+[^"[:space:]]\+\s*\|"\s*\)\=\|\s*\)$,
    \ contained
    \ nextgroup=snippetsSnippetDocString
    \ skipwhite

syn match snippetsSnippetDocString
    \ ,"[^"]*",
    \ contained
    \ nextgroup=snippetsSnippetOptions
    \ skipwhite

syn match snippetsSnippetDocContextString
    \ ,"[^"]*",
    \ contained
    \ nextgroup=snippetsSnippetContext
    \ skipwhite

syn match snippetsSnippetContext
    \ ,"[^"]\+",
    \ contained
    \ skipwhite
    \ contains=snippetsSnippetContextP

syn region snippetsSnippetContextP
    \ start=,"\@<=.,
    \ end=,\ze",
    \ contained
    \ contains=@Python
    \ nextgroup=snippetsSnippetOptions
    \ skipwhite
    \ keepend

syn match snippetsSnippetOptions ,\S\+, contained contains=snippetsSnippetOptionFlag
syn match snippetsSnippetOptionFlag ,[biwrtsmxAe], contained

" Command substitution {{{4

syn region snippetsCommand keepend matchgroup=snippetsCommandDelim start="`" skip="\\[{}\\$`]" end="`" contained contains=snippetsPythonCommand,snippetsVimLCommand,snippetsShellCommand,snippetsCommandSyntaxOverride
syn region snippetsShellCommand start="\ze\_." skip="\\[{}\\$`]" end="\ze`" contained contains=@Shell
syn region snippetsPythonCommand matchgroup=snippetsPythonCommandP start="`\@<=!p\_s" skip="\\[{}\\$`]" end="\ze`" contained contains=@Python
syn region snippetsVimLCommand matchgroup=snippetsVimLCommandV start="`\@<=!v\_s" skip="\\[{}\\$`]" end="\ze`" contained contains=@Viml
syn cluster snippetsTokens add=snippetsCommand
syn cluster snippetsTabStopTokens add=snippetsCommand

" unfortunately due to the balanced braces parsing of commands, if a { occurs
" in the command, we need to prevent the embedded syntax highlighting.
" Otherwise, we can't track the balanced braces properly.

syn region snippetsCommandSyntaxOverride start="\%(\\[{}\\$`]\|\_[^`"{]\)*\ze{" skip="\\[{}\\$`]" end="\ze`" contained contains=snippetsBalancedBraces transparent

" Tab Stops {{{4

syn match snippetsEscape "\\[{}\\$`]" contained
syn cluster snippetsTokens add=snippetsEscape
syn cluster snippetsTabStopTokens add=snippetsEscape

syn match snippetsMirror "\$\d\+" contained
syn cluster snippetsTokens add=snippetsMirror
syn cluster snippetsTabStopTokens add=snippetsMirror

syn region snippetsTabStop matchgroup=snippetsTabStop start="\${\d\+[:}]\@=" end="}" contained contains=snippetsTabStopDefault extend
syn region snippetsTabStopDefault matchgroup=snippetsTabStop start=":" skip="\\[{}]" end="\ze}" contained contains=snippetsTabStopEscape,snippetsBalancedBraces,@snippetsTabStopTokens keepend
syn match snippetsTabStopEscape "\\[{}]" contained
syn region snippetsBalancedBraces start="{" end="}" contained transparent extend
syn cluster snippetsTokens add=snippetsTabStop
syn cluster snippetsTabStopTokens add=snippetsTabStop

syn region snippetsVisual matchgroup=snippetsVisual start="\${VISUAL[:}/]\@=" end="}" contained contains=snippetsVisualDefault,snippetsTransformationPattern extend
syn region snippetsVisualDefault matchgroup=snippetsVisual start=":" end="\ze[}/]" contained contains=snippetsTabStopEscape nextgroup=snippetsTransformationPattern
syn cluster snippetsTokens add=snippetsVisual
syn cluster snippetsTabStopTokens add=snippetsVisual

syn region snippetsTransformation matchgroup=snippetsTransformation start="\${\d\/\@=" end="}" contained contains=snippetsTransformationPattern
syn region snippetsTransformationPattern matchgroup=snippetsTransformationPatternDelim start="/" end="\ze/" contained contains=snippetsTransformationEscape nextgroup=snippetsTransformationReplace skipnl
syn region snippetsTransformationReplace matchgroup=snippetsTransformationPatternDelim start="/" end="/" contained contains=snippetsTransformationEscape nextgroup=snippetsTransformationOptions skipnl
syn region snippetsTransformationOptions start="\ze[^}]" end="\ze}" contained contains=snippetsTabStopEscape
syn match snippetsTransformationEscape "\\/" contained
syn cluster snippetsTokens add=snippetsTransformation
syn cluster snippetsTabStopTokens add=snippetsTransformation

" global {{{3

" Generic (non-Python) {{{4

syn region snippetsGlobal start="^global\_s" end="^\zeendglobal\s*$" contains=snippetsGlobalHeader nextgroup=snippetsGlobalFooter fold keepend
syn match snippetsGlobalHeader "^.*$" nextgroup=snippetsGlobalBody,snippetsGlobalFooter skipnl contained contains=snippetsGlobalHeaderKeyword
syn region snippetsGlobalBody start="\_." end="^\zeendglobal\s*$" contained contains=snippetsLeadingSpaces

" Python (!p) {{{4

syn region snippetsGlobal start=,^global\s\+!p\%(\s\+"[^"]*\%("\s\+[^"[:space:]]\+\|"\)\=\)\=\s*$, end=,^\zeendglobal\s*$, contains=snippetsGlobalPHeader nextgroup=snippetsGlobalFooter fold keepend
syn match snippetsGlobalPHeader "^.*$" nextgroup=snippetsGlobalPBody,snippetsGlobalFooter skipnl contained contains=snippetsGlobalHeaderKeyword
syn match snippetsGlobalHeaderKeyword "^global" contained nextgroup=snippetsSnippetTrigger skipwhite
syn region snippetsGlobalPBody start="\_." end="^\zeendglobal\s*$" contained contains=@Python

" Common {{{4

syn match snippetsGlobalFooter "^endglobal.*" contained contains=snippetsGlobalFooterKeyword
syn match snippetsGlobalFooterKeyword "^endglobal" contained

" priority {{{3

syn match snippetsPriority "^priority\%(\s.*\|$\)" contains=snippetsPriorityKeyword display
syn match snippetsPriorityKeyword "^priority" contained nextgroup=snippetsPriorityValue skipwhite display
syn match snippetsPriorityValue "-\?\d\+" contained display

" context {{{3

syn match snippetsContext "^context.*$" contains=snippetsContextKeyword display skipwhite
syn match snippetsContextKeyword "context" contained nextgroup=snippetsContextValue skipwhite display
syn match snippetsContextValue '"[^"]*"' contained contains=snippetsContextValueP
syn region snippetsContextValueP start=,"\@<=., end=,\ze", contained contains=@Python skipwhite keepend

" Actions {{{3

syn match snippetsAction "^\%(pre_expand\|post_expand\|post_jump\).*$" contains=snippetsActionKeyword display skipwhite
syn match snippetsActionKeyword "\%(pre_expand\|post_expand\|post_jump\)" contained nextgroup=snippetsActionValue skipwhite display
syn match snippetsActionValue '"[^"]*"' contained contains=snippetsActionValueP
syn region snippetsActionValueP start=,"\@<=., end=,\ze", contained contains=@Python skipwhite keepend

" Snippt Clearing {{{2

syn match snippetsClear "^clearsnippets\%(\s.*\|$\)" contains=snippetsClearKeyword display
syn match snippetsClearKeyword "^clearsnippets" contained display

" Highlight groups {{{1

hi def link snippetsComment          Comment
hi def link snippetsTODO             Todo
hi def snippetsLeadingSpaces gui=reverse guifg=#a0a0a0
"\ hi def snippetsLeadingSpaces term=reverse ctermfg=15 ctermbg=4 gui=reverse guifg=#dc322f

hi  def  link  snippetsKeyword                     vimNumber

hi  def  link  snippetsExtendsKeyword              snippetsKeyword

hi  def  link  snippetsSnippetHeaderKeyword        snippetsKeyword
hi  def  link  snippetsSnippetFooterKeyword        snippetsKeyword

hi  clear  snippetsSnippet
"\ hi  def  link  snippetsSnippet                     Normal
hi  def  link  snippetsSnippetTrigger              Identifier
hi  def  link  snippetsSnippetTriggerInvalid       Error
hi  def  link  snippetsSnippetDocString            String
hi  def  link  snippetsSnippetDocContextString     String
hi  def  link  snippetsSnippetOptionFlag           Special

hi  def  link  snippetsGlobalHeaderKeyword         snippetsKeyword
hi  def  link  snippetsGlobalFooterKeyword         snippetsKeyword

hi  def  link  snippetsCommand                     Special
hi  def  link  snippetsCommandDelim                snippetsCommand
hi  def  link  snippetsShellCommand                snippetsCommand
hi  def  link  snippetsVimLCommand                 snippetsCommand
hi  def  link  snippetsPythonCommandP              PreProc
hi  def  link  snippetsVimLCommandV                PreProc
hi  def  link  snippetsSnippetContext              String
hi  def  link  snippetsContext                     String
hi  def  link  snippetsAction                      String

hi  def  link  snippetsEscape                      Special
hi  def  link  snippetsMirror                      StorageClass
hi  def  link  snippetsTabStop                     Define
hi  def  link  snippetsTabStopDefault              String
hi  def  link  snippetsTabStopEscape               Special
hi  def  link  snippetsVisual                      snippetsTabStop
hi  def  link  snippetsVisualDefault               snippetsTabStopDefault
hi  def  link  snippetsTransformation              snippetsTabStop
hi  def  link  snippetsTransformationPattern       String
hi  def  link  snippetsTransformationPatternDelim  Operator
hi  def  link  snippetsTransformationReplace       String
hi  def  link  snippetsTransformationEscape        snippetsEscape
hi  def  link  snippetsTransformationOptions       Operator

hi  def  link  snippetsContextKeyword              Keyword

hi  def  link  snippetsPriorityKeyword             Keyword
hi  def  link  snippetsPriorityValue               Number

hi  def  link  snippetsActionKeyword               Keyword

hi  def  link  snippetsClearKeyword                Keyword


let b:current_syntax = "snippets"
