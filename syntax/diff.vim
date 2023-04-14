"\ Language: Diff (context or unified) (跟set diff无关, 被diff的文件 如果是.vim, set ft?仍显示vim)
"\ Maintainer:   Bram Moolenaar <Bram@vim.org>
"\ Last Change:  2020 Dec 30

if exists("b:current_syntax")
    finish
en

scriptencoding utf-8

    syn match diffOnly       "^Only in .*"
    syn match diffIdentical  "^Files .* and .* are identical$"
    syn match diffDiffer     "^Files .* and .* differ$"
    syn match diffBDiffer    "^Binary files .* and .* differ$"
    syn match diffIsA        "^File .* is a .* while file .* is a .*"
    syn match diffNoEOL      "^\\ No newline at end of file .*"
    syn match diffCommon     "^Common subdirectories: .*"

" Disable the translations by setting diff_translations to zero.
if !exists("diff_translations") ||
 \ diff_translations

    " zh_CN
    syn match diffOnly       "^只在 .* 存在：.*"
    syn match diffIdentical  "^檔案 .* 和 .* 相同$"
    syn match diffDiffer     "^文件 .* 和 .* 不同$"
    syn match diffBDiffer    "^文件 .* 和 .* 不同$"
    syn match diffIsA        "^文件 .* 是.*而文件 .* 是.*"
    syn match diffNoEOL      "^\\ 文件尾没有 newline 字符"
    syn match diffCommon     "^.* 和 .* 有共同的子目录$"


en

"\ 隐藏开头的标志符号, 靠颜色区分 add和diff
    syn match diffRemovedSign @^- @ contained conceal containedin=diffRemoved
    syn match diffRemovedSign @^< @ contained conceal containedin=diffRemoved
    syn match diffAddedSign   @^+ @ contained conceal containedin=diffAdded
    syn match diffAddedSign   @^> @ contained conceal containedin=diffAdded


syn match diffRemoved "^-.*"
syn match diffRemoved "^<.*"

syn match diffAdded   "^+.*"
syn match diffAdded   "^>.*"

syn match diffChanged "^! .*"

syn match diffSubname "@@..*"ms=s+3 contained
syn match diffLine    "^@.*" contains=diffSubname
syn match diffLine    "^\<\d\+\>.*"
syn match diffLine    "^\*\*\*\*.*"
syn match diffSplit_old_new    "^---$"
hi diffSplit_old_new guibg=#e9e9e0 gui=none guifg=#007000
"\ syn match diffLine    "^---$"

"\ Some versions of diff have lines like:  (where # is a number)
    "\ ¿#c#¿
    "\ ¿#d#¿
    "\ ¿#a#¿
syn match diffLine_Num_What_Num  "^\d\+\(,\d\+\)\=[cda]\d\+\>.*"
hi diffLine_Num_What_Num guibg=#888888 guifg=#ffffff

hi diffLineChange_del_Add guibg=#ffffff guifg=#aa0000
call matchadd('diffLineChange_del_Add',   '^\d\+\(,\d\+\)\=\zs[cda]\ze\d\+\>.*',   99)
    "\ 如果直接用  syn match,
    "\ 因为已经被diffLine_Num_What_Num匹配, 就无法再靠加 \zs 和 \ze匹配

syn match diffFile  "^diff\>.*"
syn match diffFile  "^Index: .*"
syn match diffFile  "^==== .*"

if search('^@@ -\S\+ +\S\+ @@', 'nw', '', 100)
    " unified
    syn match diffOldFile "^--- .*"
    syn match diffNewFile "^+++ .*"
el
    " context / old style
    syn match diffOldFile "^\*\*\* .*"
    syn match diffNewFile "^--- .*"
en

" Used by git
syn match diffIndexLine "^index \x\x\x\x.*"

syn match diffComment   "^#.*"

" Define the default highlighting.
    hi def link diffOldFile     diffFile
    hi def link diffNewFile     diffFile
    hi def link diffIndexLine   PreProc
    hi def link diffFile        Type
    hi def link diffOnly        Constant
    hi def link diffIdentical   Constant
    hi def link diffDiffer      Constant
    hi def link diffBDiffer     Constant
    hi def link diffIsA     Constant
    hi def link diffNoEOL       Constant
    hi def link diffCommon      Constant
    hi def link diffRemoved     Special
    hi def link diffChanged     PreProc
    hi def link diffAdded       Identifier
    "\ hi def link diffLine        Statement
    hi def link diffSubname     PreProc
    hi def link diffComment     Comment


"\ diffchar
    hi dcNormal                                      guifg=fg       guibg=bg
    hi dcCursor        gui=reverse,nocombine         guifg=#444444
    hi dcDiffChange                                  guifg=fg       guibg=bg
    hi dcDiffText      gui=bold,nocombine            guifg=#444444  guibg=none
    hi dcDiffAdd       gui=nocombine                 guifg=#444444  guibg=none
    hi dcDiffDelEdge   gui=bold,underline,nocombine  guifg=#444444  guibg=none
    hi dcDiffDelete    gui=bold,nocombine            guifg=Blue     guibg=none



let b:current_syntax = "diff"

