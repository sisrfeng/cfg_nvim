" 来自
" ~/d/leo_tools/coc/extensions/node_modules/coc-snippets
"\ sm: snip mate 的意思 (不是sex ·)


" Syntax highlighting variant
  "\ used for ¿snipmate¿ snippets files
" The snippets.vim file sources this if it wants snipmate mode

if exists("b:current_syntax")  | finish  | en

" Embedded syntaxes
    " Re-include the original file so we can share some of its definitions
    let b:ultisnips_override_snipmate = 1
    syn include <sfile>:h/snippets.vim
    unlet b:current_syntax
    unlet b:ultisnips_override_snipmate

    syn cluster snippetsTokens        contains=snippetsEscape,snippetsVisual,snippetsTabStop,snippetsMirror,snippetsmateCommand
    syn cluster snippetsTabStopTokens contains=snippetsVisual,snippetsMirror,snippetsEscape,sm_snippetsCommand

" Syntax definitions
    "\ lwf定义的:
    syn match sm_snippetsDeli    "^# "     contained  containedin=sm_snippetsComment conceal

    syn match sm_snippetsComment "^#.*"  contains=sm_snippetsTODO,@In_fancY  display

    syn match sm_snippetsExtends "^extends\%(\s.*\|$\)" contains=snipExtendsKeyword display

    syn region sm_snippetsSnippet
                 \ start="^snippet\ze\%(\s\|$\)"
                   \ end="^\ze[^[:tab:]]"
                 \ contains=sm_snippetsSnippetHeader
                 \ keepend

    syn match sm_snippetsSnippetHeader   "^.*"
                 \ contained
                 \ contains=sm_snippetsKeyword
                 \ nextgroup=sm_snippetsSnippetBody
                 \ skipnl skipempty

    syn match sm_snippetsKeyword   "^snippet\ze\%(\s\|$\)"
                \ contained
                \ nextgroup=sm_snippetsTrigger
                \ skipwhite

    syn match sm_snippetsTrigger  "\S\+"
                \ contained
                \ nextgroup=sm_snippetsDescription
                \ skipwhite

    syn match sm_snippetsDescription  "\S.*"  contained

    syn region sm_snippetsSnippetBody
                    \ start="^\t"
                    \ end="^\ze[^[:tab:]]"
                    \ contained
                    \ contains=@snipTokens

    syn region sm_snippetsCommand
                    \ keepend
                    \ matchgroup=snipCommandDelim
                    \ start="`"
                    \ skip="\\[{}\\$`]"
                    \ end="`"
                    \ contained
                    \ contains=snipCommandSyntaxOverride,@Viml

" Highlight groups

hi def link sm_snippetsComment snippetsComment

"\ 这些命名看着有点头晕, 但在/home/wf/dotF/cfg/nvim/syntax/snippets.vim里看就挺清晰(那里会恰当地conceal)
hi  def  link  sm_snippetsKeyword      snippetsKeyword
hi  def  link  sm_snippetsSnippet      snippetsSnippet
hi def link sm_snippetsCommand      snippetsCommand

hi  def  link  sm_snippetsTrigger      snippetsSnippetTrigger
hi  def  link  sm_snippetsDescription  snippetsSnippetDocString



"\ todo: syntax显示有有问题
"\ let b:current_syntax = "snippets"  "\ 这行是官方写的  文件后缀名是snippets, 所以syntax也是这个 合理
" }}}1

let b:current_syntax = "sm_snippets"
                  "\ sm: snip mate的意思
"\ 这导致python.snippets的syntax不等于后缀名 有潜在风险?
