if exists('s:loaded_mm')
    if debug_mode_wf == 1
        echom 'let g:debug_mode_wf = 0  敲了就可以退出wf的debug模式  |||  在debug, 执行了unlet s:loaded_mm'
        unlet s:loaded_mm
            "\ todo 这可能导致进入mm文件会变慢
    el
        finish
        "\ 如果这里用finish:
            " 这个文件改了后, 要重启nvim才生效
            " (这就导致在ReloaD()里用 Runtime /home/wf/dotF/cfg/nvim/autoload/mm.vim 无效)

            " 官方的很多autoload  都是用g:loaded_某某
            " 但官方的本文件用s:loaded_mm, 而非g:
            " 因为plugin/mm.vim里有这个定义:
            " command! -bang mm
            " (要让任何buffer里都能用:mm, 所以放在在plugin/ 而非ftplugin/)

            " 如果这里用g:loaded_mm, 导致
            " 在非mm的buffer里, plugin/mm.vim会finish:
                " if exists('g:loaded_mm')
                "   finish
                " endif
                " let g:loaded_mm = 1

            " 或者手动unlet s:loaded_mm?
                "\ s:开头的变量, 只能在本script操作
    endif
endif

let s:loaded_mm = 1


function! mm#Short_maN()
    "\ echo '调用 mm#Short_maN'
    exec '% subs#\v\S\zs  \ze\S# #ge'
                    " 行内的2个空格变1个
    "\ 缩进变为4的倍数
        silent! % sub #\v^ {1,3}\ze\S#    #ge
        silent! % sub #\v^ {5,7}\ze\S#        #ge
        silent! % sub #\v^ {9,11}\ze\S#            #ge

    silent! % sub #💚#`#ge
    silent! % sub #💛#`#ge

    "\ todo nroff可控制如何用hypen断句
    "\ https://stackoverflow.com/questions/23546272/in-linux-hyphen-is-a-multi-character-character
        % sub #\v\w\zs‐ {1,3}\ze\w##ge
        % sub #‐\n *\ze\w##ge
                   "\ 这里短横线这个字符, 是hypen (unicode 8208), 而非下面的¿-¿ (键盘上直接敲)
        "\ % sub #\v\w\zs- {1,3}\ze\w##gce

    silent! % sub #\v^\s*\zs(please )?note that ##ge
    call funcS#Short_iT()
    "\ norm! `s  \ 不生效, 挪到map里
    2  "\ 跳到第2行
endfunction


fu! mm#TOC_leo() abort
    let _bufname = bufname('%')
    " 删了这段 会导致有时变慢?
    let info = getloclist(0, {'winid': 1})
    if  !empty(info) &&
     \ getwinvar(info.winid, 'qf_toc') ==# _bufname
        echom '进了/home/wf/dotF/cfg/nvim/autoload/mm.vim的  if分支'
        lopen
        return
    else
        let toc_lines = []
        let lNum = 2
        let last_line = line('$') - 1
        while lNum >0 && lNum < last_line
            let add_text = getline(lNum)
            " if add_text =~ '\v^\s{3,4}\S.*$' || add_text =~ '\v^\S.*$'
            if add_text =~ '\v^\s{3}\S.*$' || add_text =~ '\v^\S.*$'
                                  " 空格数为3    或0      或者4空格 数字 一个点. 空格 (numbered list)
            " if add_text =~# '\v^' .. '(' .. '( {3})|' .. '|' .. '( {4}\d\. )' .. '( {4}• )' .. ')\S.*$'
                                                                                      " 字符• 太特殊 不行?
                                                                                      " 不用numbered list 就全用0吧
                let level = count(add_text, '^ ') > 0 ? 1 : 0

                let add_text = substitute(add_text, '\v\s+$', '', 'g')
                call add(  toc_lines,
                          \{
                          \'bufnr'  : bufnr('%'),
                          \'lnum'   : lNum,
                          \'text'   : '++++'->repeat(level) .. add_text,
                           "\ 单引号里的空格会被清掉,  无法缩进
                          \},
                        \)
            endif
            let lNum = nextnonblank(lNum + 1)
        endwhile

        call setloclist(0, toc_lines, ' ')
        call setloclist(0, [], 'a', {'title': 'mm TOC'})
        lopen
        let w:qf_toc = _bufname
    endif
endf

