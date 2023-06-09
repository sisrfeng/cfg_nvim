"\ todo: 改用lua
let g:do_legacy_filetype = 1

au AG BufEnter *massren/temp/*.files.txt  nno <buffer> qq  :echom '不改名了_准备结束massren进程'<cr>:earlier 999999d<cr>:wq<cr>
                "\ if fnameescape( expand("%:p") )   =~ 'dotF/cfg/massren/temp/.\+\.files\.txt'
    "\ 这样可以避免:
    "\ massren: 打开了临时文件后, 如果不:write 而是:q!, 回到zsh要敲一次ctrl c  \

"\ au AG BufAdd *   不行
au AG BufEnter *
        \ if bufname() =~ 'dap-repl'
            \| nno <buffer> <c-x> <c-w>k
        \| endif

" 很多插件里都有这行,
    " if !exists('g:no_plugin_maps')  没必要吧

" Todo 全改成 形如 FileType tex ?


" au AG WinNew,BufReadPost,BufNew,BufEnter,BufWinEnter,BufAdd,WinNew    *
au AG WinNew    *
    \ if &buftype == 'nofile' && exists('w:kind')
    \|    if w:kind == 'close' || w:kind == 'notification'
          \ echo '又弹窗了'
          \ hide
          \| endif
    \| endif


au AG BufReadPost /tmp/*.vim   call Tmp_bufferS()
    fun! Tmp_bufferS()
        set noswapfile
        set bufhidden=delete

        nno <CR>   "fy<Cmd>call  g:Goto_filE()<CR>
    endf

" au AG BufEnter
    "\ \ *Coc\ List\ Preview*,list:*yank
    "\ \ nno  <silent><nowait><buffer> <esc> <esc>

    " help里说无法map <esc>


au AG FileType mm,help,txt    call Doc_cfg()
    fun! Doc_cfg()
        nno tD   <Cmd>call funcS#To_digiT()<cr>
    endf


" buffer local options
    au AG FileType python
        \ setl iskeyword=@,48-57,_

                         " 默认的help里的'iskeyword':  nearly all ASCII chars except ' ', '*', '"' and '|'

    "\ 这里如果不加silent, 刚进nvim时, 会echo类似这个:
        "\ silent!  au AG BufWritePre  <buffer=abuf>  call <SID>Remove_end_white_space()
        "\ (在/home/wf/dotF/cfg/nvim/init.vim有)
    sil au AG FileType zsh,txt
               syn iskeyword @,48-57,_,192-255,#,-
        \ setl iskeyword=@,48-57,_,-
                                   " 1. 若不加连字符, aa-import pudb; pu.db 就不是一个word
                                   " 2. 之前加了¿#¿, 但会导致#替换时, ctrl w多删了井号
                                   " 3. 官方默认值里有192-255 是奇奇怪怪的西文, 我用不着,删掉了
                                   " 4. 如果中英文挨在一起  会被当做一个word, 不便于删除单词
    au AG FileType help
        \ setl iskeyword=@,48-57,_,-
                                 "\ 如果不加-, 敲gh时 无法复制整个tag

    au AG FileType vim
        \ setl iskeyword=@,48-57,_
                                  "\ 加¿-¿会导致¿XXX-¿被当作一个word?
                                        "\ set XXX-=yyyyy

        " vim的iskeyword在" ~/PL/scriptV/plugin/scriptV.vim也被改动(现在应该没问题了):

" python
    au AG BufEnter,BufAdd /home/wf/Man/py_help/python-3*-docs-text/*.txt     set ft=pyh
    au AG BufEnter        *.py,*.pyh                                         call Python_map()
        fun! Python_map()
            nno gh    "pyiW<cmd>call Func_as_cmd_python_map()<cr>
            vno gh      "py<cmd>call Func_as_cmd_python_map()<cr>
                                     "\ Func_as_cmd_python_map: 直接在nno后敲命令 要处理escape, 麻烦, 所以塞进函数里
        endf

                                  fun!  Func_as_cmd_python_map()
                                     call chansend(g:term_jobS[-1], '多余字符串_让之前敲的命令失效_避免误操作 ; ph ' . @p . "  \<cr>" )
                                  endf

    " 手动触发
    "\ (容易漏掉某些文件 忘记加我的diy)
        " nno <Leader>P    <Cmd>call funcS#Py_wf()<cr>
                    " p: python

                    "\ import leo啥的

    " 需要再临时取消注释, 避免modify too many files, make git history dirty!!!
    " ps:修改后不会自动update

        "\ au AG BufNewFile,BufReadPost  *.py
        "\                         \ if hostname() != 'redmi14-leo'
        "\                         \ && bufname() !~ 'leo_base.py' && bufname() !~ '__init__.py'
        "\                         \ |   call  funcS#Py_wf()
        "\                         \ | endif

        " :E **/*.py
        " arg list的文件, 一定在buffer list上, 但可能没有load? 所以不触发上述autocmd?
        " :argdo update 也无法上上述autocmd生效
        " :argdo write  也许可以

"\ lua
    let lua_version = 5.1
    "\ 影响:
    "\ /home/wf/dotF/cfg/nvim/syntax/lua.vim
    "\ nvim用5.1, lua5.1 and later lua are different languages

" preview
    " au AG BufLeave * if &previewwindow == 1 | bdelete | endif
                      " E441: There is no preview window

    au AG BufEnter *log_TeX    call g:Need_jumP()
        fun! g:Need_jumP()
            nno <buffer>  gj     /\v\S +:\d+$<cr>
                                \$"lyiw
                                \bb
                                \"fyiW
                                \:-tab drop <c-r>f<CR>
                                \:<c-r>l<cr>
        endf


    au AG BufEnter /tmp/*
        \ if &previewwindow
            \| call Short_previeW()
                \| if g:keyword_can_be_used == 1 | echom '键位可用' | endif
          \| endif

        fun! Short_previeW()
            let g:keyword_can_be_used = 0
            "\ if search('No mapping found')
                "\ silent! bdelete
                "\ 这导致 本想在 /tmp/啥啥 的buffer里执行的 :sub  在本文件执行
                "\ let g:keyword_can_be_used = 1
                "\ return
            "\ endif

            set modifiable

            "\ j: jump to the line
            "\ todo: 和gf合并, 智能化
            nno <buffer>  gj     /\sline\s\d\+$<cr>
                                \$"lyiw
                                  "\ "l: line number
                                \bb
                                \"fyiW
                                 "\ "f:  file
                                 \<Cmd>q<CR>
                                 \<Cmd>stopinsert<CR>
                                 "\ 避免terminal mode里出错
                                \:-tab drop <c-r>f<CR>
                                \:<c-r>l<cr>


            if search('last set from')

                sil % sub #\v\d+\zs$#\r\r#ge
                                "\ 换行
                let a_str = repeat(' ', 20)
                sil % sub #\v\s*last set from#\=a_str#ge
                sil % sub #\vlast set from#\=repeat('', 15)#ge
                sil % sub #no mapping found##ge
                sil % sub #\v.{15,18}\zs\*?\&?\@?##ge
                         "\ *号出现在16列 或被<space>等往后推几列
                 norm! gg
                 "\ norm! ggdd
            elseif  search('--- Syntax items ---')
                sil % sub #--- Syntax items ---##ge
            en
        endf



" json系
    au AG BufNewFile,BufReadPost *  if &ft =='jsonc'
        \| ino <buffer> ' "
        \| ino <buffer>  " '
        \| en
    au AG BufNewFile,BufReadPost *  if &ft =='json'  | ino <buffer> ' " | ino <buffer>  " ' | en

" markdown
    "\ /home/wf/PL/markdown/after/ftplugin/markdown.vim

" rst
    au AG FileType rst       nno <buffer> go   <Cmd>call funcS#Out_linE('^---')<cr>
    au AG FileType rst       nno <buffer> gO   <Cmd>call funcS#Out_linE('^===')<cr>

" tex
    fun! To_tex_quickfiX()
        if empty(getqflist())
            echo 'getqflist为空, latex没毛病'
        el
            -tab drop ~/d/tT/wf_tex/PasS.tex
            let g:wf_vimtex_stick_to_qf = 1
            call vimtex#qf#open(1)
            let g:wf_vimtex_stick_to_qf = 0
        en
    endf

    au AG BufReadPost  *.tex  call Tex_reaD()
          " bufread 不宜放到ftplugin/某某.vim?
    fun! Tex_reaD()
        call funcS#Out_linE('\v\\(sub)?section\{.{-}}$')
        norm! 2zl
            " fun! Tex_outlinE()
            "     call funcS#Out_linE('\v\\(sub)?section\{.{-}}$')
            " endf
            " call Tex_outlinE()

        " echo '如果觉得莫名多一处undo,来这里看看'
        % sub #\Vbegin{document}#begin{document}#e


        nno   <Leader>w    <Cmd>call To_tex_quickfiX()<cr>
    endf

" vim系
    fun! g:Option_iS() abort
        exe 'normal! "oyiw'
        let @o = substitute(@o, "'", '','g')
        " echom '@o是'
        " echom @o
        " echom '@o是'

        exe 'let @" = &' .. @o
                " 寄存器" 放着option的值, 方便paste
        exe 'Verbose set' @o .. '?'
    endf

    " help
    " 搬到help.vim了

    " vim
        au AG FileType vim,help     call Vim_maP()
        fun! Vim_maP()
            nno <silent> <buffer>  wo         <Cmd>call Option_iS()<cr>
            vno <silent> <buffer>  wo        "oy<cmd>exe 'Verbose set' @o..'?'<cr>

            nno <buffer>           si         <cmd>call vim#Short_iT()<cr>
            nno <buffer>           <M-k>      i\ <esc>
            nno <buffer>           <M-Bslash>   <Cmd>call Short_linE()<cr>
            nno <buffer>           <cr>       <Cmd>call vim#To_taG()<cr>
                                 " 和help.vim里冲突?
        endf

        fun! Short_linE()
            mark b
            let _indent = indent('.') - 1
            let _indent2 = indent('.') + 4
            echom _indent
            norm i\
            exe "left" _indent2
            norm  k
            norm  j
        endf


        au AG FileType zsh,bash,sh     call Zsh_maP()
        fun! Zsh_maP()
            nno <buffer>           <M-k>      i\ <esc>
            nno <buffer>           <M-Bslash> i\ <esc>
        endf


            " 傻逼错误, 浪费20min:
                " au AG BufNewFile,BufReadPost *.vim
                "     \| vno <silent> <buffer>  wo "oy<cmd>exe 'Verbose set' @o..'?'<cr>
                "     \| nno <silent> <buffer>  wo  <Cmd>call Option_iS()<cr>

                " 之前这里用了if 换行时才用 ¿\|¿
                " au AG BufNewFile,BufReadPost *  if &ft =='help'
                    " \| call Help_maP() | en

                " 这里又忘了在最后一行加 竖线
                " au AG BufNewFile,BufReadPost *.vim
                "     \ vno <silent> <buffer>  wo "oy<cmd>exe 'Verbose set' @o..'?'<cr>
                "     \ nno <silent> <buffer>  wo  <Cmd>call Option_iS()<cr>

" w3m
    au AG BufWriteCmd *w3m*  write | set modifiable | echom 'lllllllllllllllllll__w3m'


"\ 二进制
    aug  Binary
        au!
        au  BufReadPre    *.bin,TabNine-deep-cloud,TabNine-deep-local   let &bin=1
        au  BufReadPost   *.bin,TabNine-deep-cloud,TabNine-deep-local   if &bin | %!xxd
        au  BufReadPost   *.bin,TabNine-deep-cloud,TabNine-deep-local   set ft=xxd | endif

        au  BufWritePre   *.bin,TabNine-deep-cloud,TabNine-deep-local   if &bin | %!xxd -r
        au  BufWritePre   *.bin,TabNine-deep-cloud,TabNine-deep-local   endif

        au  BufWritePost  *.bin,TabNine-deep-cloud,TabNine-deep-local  if &bin | %!xxd
        au  BufWritePost  *.bin,TabNine-deep-cloud,TabNine-deep-local  set nomodified | endif
    aug  END

