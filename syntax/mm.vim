" Maintainer:          Anmol Sethi <hi@nhooyr.io>
" Previous Maintainer: SungHyun Nam <goweol@gmail.com>

if exists('b:current_syntax')
    finish
en

" define syntax
    syn    case  ignore


    syn    match mmLine1         display '^\%1l.*$'
                                        " \%23l   Matches in a specific line.
    hi default link mmLine1         Title

    syn    match mmSectioN       display '^\S.*$'
    hi default link mmSectioN Statement

    syn    match mmSub_sectioN    display '^ \{3\}\S.*$'
    syn    match mmSub_sectioN2    display '^ \{4\}\S.*$'
    hi default link mmSub_sectioN      Function
    hi default link mmSub_sectioN2     Ignore

    syn    match mmOptionDesc     display '^\s\+\%(+\|-\)\S\+'
    hi default link mmOptionDesc     Constant

    syn    match mmReference      display '[^()[:space:]]\+(\%([0-9][a-z]*\|[nlpox]\))'
    hi default link mmReference      PreProc


    hi default mmUnderline gui=underline
    hi default mmBold      gui=bold
    hi default mmItalic    gui=italic

if &filetype != 'mm'
    " May have been included by some other filetype.
    finish
en


" C语言/system related
if get(b:, 'mm_sect', '') =~# '^[023]'
    " section
       " 2   System calls (functions provided by the kernel)
       " 3   Library calls (functions within program libraries)
    syn    case match
    syn    include @c $VIMRUNTIME/syntax/c.vim
    syn    match mmCFuncDefinition     display '\<\h\w*\>\ze\(\s\|\n\)*(' contained
    syn    match mmLowerSentence /\n\s\{7}\l.\+[()]\=\%(\:\|.\|-\)[()]\=[{};]\@<!\n$/ display keepend contained contains=mmReference
    syn    region mmSentence start=/^\s\{7}\%(\u\|\*\)[^{}=]*/ end=/\n$/ end=/\ze\n\s\{3,7}#/ keepend contained contains=mmReference
    syn    region mmSynopsis start='^\%(
                                      \SYNOPSIS\|
                                      \SYNTAX\|
                                      \SINTASSI\|
                                      \書式\)$'
                \end='^\%(\S.*\)\=\S$' keepend contains=mmLowerSentence,mmSentence,mmSectioN,@c,mmCFuncDefinition
    hi default link mmCFuncDefinition Function

    syn    region mmExample start='^EXAMPLES\=$' end='^\%(\S.*\)\=\S$' keepend contains=mmLowerSentence,mmSentence,mmSectioN,mmSub_sectioN,@c,mmCFuncDefinition

    " XXX: groupthere doesn't seem to work
    syn    sync minlines=500
    "syntax sync match mmSyncExample groupthere mmExample '^EXAMPLES\=$'
    "syntax sync match mmSyncExample groupthere NONE '^\%(EXAMPLES\=\)\@!\%(\S.*\)\=\S$'
en

" Prevent everything else from matching the last line
exe     'syntax match mmFooter display "^\%'.line('$').'l.*$"'


let b:current_syntax = 'mm'
