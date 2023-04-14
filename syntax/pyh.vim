"\ pyh: py help
"\ 这行会调用本文件:
"\ let last_line =  'wf_py_doc   .....

if exists("b:current_syntax")  | finish  | endif

set noshiftround

"\ 来自  /home/wf/dotF/cfg/nvim/syntax/help.vim:
    syn match StaR   "\*"  contained conceal
    " last win失败的特例:
        " - An item that ¿starts in an earlier position¿
        "     (show in the target file, which you are using syntax group)
        "     has priority over  items that start in later positions.

    "\ hi  In_StaR  guibg=none gui=none guifg=#e0eada "\   浅色 勉强能辨别
    hi  In_StaR  guibg=none gui=none guifg=#107240 "\   深绿色
    " " hi  In_StaR    guifg=#a05058 gui=none
        syn match In_StaR        "\v\*[#-)!+-~ ]+\*"         contains=StaR
        syn match In_StaR_erroR        "\v\*E\d+\*"         contains=StaR conceal

    "
    hi  link In_StaR_EOL In_backticK
    " 明明在¿/XX¿搜索时可以匹配到行末的helptag,
    " 改highlight group却不生效 treesitter也显示无highlight
    syn match In_StaR_EOL    "\v[[:graph:]]\s{2,}\zs\*[#-)* +-~]+\*$"  conceal
                                   " [[:graph:]] 如何用\p等代替?
                                           " \s:用空格不好, 有些地方是tab
    syn match In_StaR_EOL    "\v^\s{9,}\zs\*[#-)* +-~]+\*$"            conceal
                                        " 别用conceal
                                        " (有些help_tag 被我拿来当小标题了)
                                        " \p\s+: 排除掉位于行首(作为小标题)的情况
                                        " \S\s+遇到中括号 或大括号结束时, 不能匹配
                                        " 为啥有的内容 能被这个regex 匹配, 但还是In_StaR的高亮?

    "\ syn match In_StaR_heaD    "\v^\*[#-)!+-~]+\*$"               conceal
    "\ 行首的helptag

syn region  rstDouble_BackTick  concealends matchgroup=conceal  start=/``/ end=/``/
so $nV/after/syntax/rst.vim

syn match pyhHide @:py:@       conceal
syn match pyhHide @:keyword@   conceal

let b:current_syntax = 'pyh'
