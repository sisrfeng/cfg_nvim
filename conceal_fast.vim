

"\ 在tmux下 nvim里的terminal的输出可以conceal
"\ todo:
    "\ runtime/lua/vim/treesitter/highlighter.lua
        "\ conceal = metadata.conceal

    "\ 例子
    "\ ~/PL/org_mode_lua/lua/orgmode/colors/markup_highlighter.lua
        "\ vim.api.nvim_buf_set_extmark(bufnr,
        "\                              namespace,
        "\                              range.from.start.line,
        "\                              range.from.start.character,
        "\                              {  end_col = range.from['end'].character,
        "\                                 ephemeral = true,
        "\                                 conceal = ''
        "\                              }
        "\                             )
"\ 对付表格, 删掉¿|¿
    "\ ReplaceEnd \ \zs|$
    "\ ReplaceEnd \ \zs|\ \ze

syntax on
au AG BufEnter * filetype detect

set lazyredraw
set conceallevel=2 concealcursor=n
set synmaxcol=260
set redrawtime=800
let g:vimsyn_maxlines = 180  " 默认60
let g:vimsyn_minlines = 100

"\ au My_syn BufLeave * call clearmatches()
    "\ vsplit时, 不想反复切换conceal
au My_syn BufLeave *        if winnr('$') < 2 | call clearmatches()  | en
" ms
" set synmaxcol=140


" helper
    nno <Leader>ht   viw<cmd>TSCaptureUnderCursor<cr>
    "\ nno <Leader>ht   viw<cmd>TSCaptureUnderCursor<cr><esc>
    vno <Leader>ht      <cmd>TSCaptureUnderCursor<cr>

    nno <Leader>o  <cmd>call Syn_stack_herE()<cr>
    vno <Leader>o  <cmd>call Syn_stack_herE()<cr>

        func! Syn_stack_herE()
            let _syntax_ = &syntax
            let g_name = []
            for id in synstack( line("."), col(".") )
                call add( g_name, synIDattr( id, "name" ) )
            endfor

            let depth = len(g_name)
            if  depth == 0
                echo '不属于任何syntax group, 由matchadd()产生?'
            el
                "\ let ver_file     = &verbosefile
                let g:f_tmp      = '/tmp/preview即用即弃' . '.vim'
                "\ let g:f_tmp      = tempname() . '.vim'
                                    "\ 会写到上一次的tempname(), set option要在函数结束才生效?
                                    "\ 用下面的代替let &也不行:
                                    "\ exe 'set verbosefile=' . g:f_tmp

                "\ let &verbosefile = g:f_tmp
                silent! call writefile([''] , g:f_tmp,'')  " 清空旧文件

                "\ 还是不能auto wrap:
                    setl formatoptions+=t
                    setl textwidth=90  " 150快到尽头了


                "\ 放syn list前, 导致显示不全:
                    "\ exe 'pedit' g:f_tmp . '|wincmd P'


                for i in range(depth)
                    let _name = remove(g_name, -1)
                    exe 'redir >>' g:f_tmp
                        silent exe 'syn list' _name  ' |  echo "  "'
                    redir END
                endfor

                exe 'pedit!' g:f_tmp  '| wincmd P | norm gg'
                "\ ✗好处是随时丢弃, 不会提醒保存, 不像这个:✗
                "\ ✗exe 'split' g:f_tmp✗
                "\ 随时丢弃 要靠这行? :
                sil! setl buftype=nowrite

                let g:tmp_match_id =  matchadd('Conceal', _syntax_ . '\ze\u', 99)
                sil! % sub # \zsxxx\ze #   #ge

                "\ /变为#, 方便conceal, 但可能buggy
                sil! % sub @\v(\=|\s)\zs\/\ze\S@#@ge
                sil! % sub @\S\zs\/\ze\s@#@ge
                sil! % sub @\S\zs\/\ze\s@#@ge
                sil! % sub @links to @\r    链到@ge

                norm! ggdd

                let in_dent = ' ' ->repeat(4)
                "\ let in_dent = ' ' ->repeat( col('.') - 1 )
                mark t
                sil! exe  "'t,$ sub#" . '[^ \\]\zs \+\ze\S' . '#' . ' \r' . in_dent . '\\ '  . '#ge'

                norm! `t
                sil! norm  zL

                "\ call Comma_dowN()
            en
        endf
            "\ au AG   BufLeave /tmp/preview即用即弃.vim    call matchdelete(g:tmp_match_id, 如何上一个)

            "\ 避免逗号后一大串, (失败...)
                "\ au AG   BufEnter /tmp/preview即用即弃.vim    call Beautify_tmp_filE()
                "\     fun! Beautify_tmp_filE()
                "\         sil! exe "norm! /\\v\contains\zs\=\ze(\\w|\\@)+,(\\w|\\@)\<cr>h"
                "\         let in_dent = ' ' ->repeat( col('.') - 8 )   "\ contains用一个符号显示了
                "\         sil! exe  '.,$ sub#' . '\v(\w|\@|\.\*)\zs,\ze(\w|\@)' . '#' . ',\r' . in_dent . '\\'  . '#ge'
                "\     endf

"\ nno gh
    " 改成buffer specific的吧,
    " vim的详见:
        "\ func! scriptV#synnames(...) abort

" hide
    au My_syn Syntax * hi HidE      guifg=#fdf6e3   guibg=none gui=none
    nno  ,h "hyiw<esc>:let a_id = matchadd('HidE', @h, 99, -1)<cr>
    vno  ,h "hy<esc>:  let a_id = matchadd('HidE', @h, 99, -1)<cr>
                                                        " 非Conceal这个group,
                                                        " 加了  {'conceal':'☾'}
                                                        " 也没用
" c: conceal
" conceal 太长, 以后用xX代替? x像封条

    nno  ,r  <Cmd>call matchdelete(g:a_id)<cr>
    nno  ,R  <Cmd>call clearmatches()<cr>

    nno  ,c "cyiw<esc>:let g:a_id = matchadd('Conceal', @c, 300, -1, {'conceal':'☾'})<cr>

    " e和r紧挨着
    " 强行记忆: e for :  expression?
    vno  ,E  <Cmd>call Concel_thiS("")<cr>
    vno  ,e  <Cmd>call Concel_thiS()<cr>
        fun! Concel_thiS(c_char='')
            norm "cy
            let @c = @c ->substitute(
                              \ '\.',
                              \ '\\.',
                               \ '',
                              \ )

            "\ 不行
            "\ let @c = @c ->substitute(
            "\                   \ '\',
            "\                   \ '\\',
            "\                    \ '',
            "\                   \ )
           echom  @c
           let g:a_id = matchadd('Conceal', @c, 100, -1, {'conceal': a:c_char})
        endf
    vno  ,E  <Cmd>call Concel_thiS("")<cr>
    " vno  ,c "cy<esc>:let a_id = matchadd('Conceal', @c, 100, -1, {'conceal':'☾'})<cr>



" matchadd比syn match 慢?
" todo:

fun! g:Match_xX( v_regex, cchar) abort
    exe "call matchadd('Conceal', '\\v"  . a:v_regex . "', 130, -1, {'conceal': '" . a:cchar . "'})"
                                    " pattern要用单引号包裹
    "\ 之前在这里用
    "\ exe 'autocmd My_syn Syntax' a:lan call matchadd('Conceal', '\\v" . a:v_regex . "', 130, -1, {'conceal': '" . a:cchar . "'})"
    "\ 导致ReloaD慢死
endf

au My_syn Syntax perl call Match_xX('# ', '')
"\ 不生效:
"\ au My_syn Syntax perl syn match  perl_com_delI     "# "    contained  containedin=perlComment



au My_syn Syntax *  call Bye_alL()
" au My_syn Syntax [^{/home/wf/dotF/cfg/nvim/coc-settings.json}]* call Bye_alL()
            " exclude specific file pattern
            "\ 失败....

        fun! Bye_alL()


            let all_byE = {
                \ '!\=(\?|#)?'                       :  '≠'           ,
                  "\ 不等号 考虑大小写的处理
                \ 'between (<\w\w{-}> )+\zsand\ze \w'  :  '⇔'         ,
                \ '<etc>\.'                            :  '⋯'         ,
                "\ \ '%(^| )\zsreturn\ze%( |$)'           :  '↵'         ,
                \ '\c<(please )?note (also |further )?that>( |,)'                    :  ''          ,
                \ '\c(do )?keep in mind that>( |,)'                    :  ''          ,
                \ '\c<note also '                    :  ''          ,
                \ 'e\.g\.,?'                    :  'שּ'                ,
                \ 'i\.e\.,?'                    :  'שּ'                ,
                \ '<note:\s'                        :  ''          ,
                "\ \ '<note:\ze\s'                        :  ''          ,
                "\ \ '\~\ze\/'                        :  '·'          ,
                "\ \ '\~\/'                        :  '·'             ,
                "\ 导致对不齐
                "\ \ 'byte'                             :  '♪'           ,
                \ '\<kbd>'   :  ''                                    ,
                "\ 对付html(另外, markdown会用html的语法)
                "\ \ 'https?:\/\/%(github.com\/%(sisrfeng\/))'   :  '♂'  ,
                "\ \ 'https?:\/\/%(gitee.com\/%(llwwff\/))'      :  '♂'  ,
                \ 'https?:\/\/gitee.com\/'                 :  'שׂ'  ,
                \ 'https?:\/\/github.com\/'                :  'שּׁ'  ,
                \ 'https?:\/\/%(github.com|gittee.com)@![^ ]{30,}'  :  '┄' ,
                "\ \ 'https?:\/\/%(github.com\/sisrfeng|gittee.com\/llwwff)@![^ ]{30,}'  :  '┄' ,
                \}
                    "\ 隐藏url:
                        " 从mdInlineURL改过来
                            "\ 这个来自markdown的mdInlineURL, 太复杂 太严谨了:
                        "\ call matchadd(
                        "\ \ 'Conceal'         ,
                        "\ \ 'https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*'  ,


            for [r,c] in items(all_byE)
                call Match_xX(r, c)
            endfor
        endf

" 导致进入terminal 会弹出echo窗口
    " au My_syn Syntax *
    "     \ | if &syntax != 'vim'
    "     \ |   call Bye_all_not_viM()
    "     \ | endif
"\ Bye_viM()  搬去了/home/wf/dotF/cfg/nvim/after/syntax/vim.vim
au My_syn Syntax python,zsh,tmux    call Bye_all_not_viM()
    fun! Bye_all_not_viM()
            let all_not_vim_byE = {
                \  '\s+\zs\\$'                    :'↙️' ,
                \}

            for [r,c] in items(all_not_vim_byE)
                call Match_xX(r, c)
            endfor
    endf
"
"
"
"\ language specific

    " help
    au My_syn Syntax help call matchadd('Conceal', '\v^\s*\zsif>' , 99, -1, {'conceal':'▸'})

    " tex的挪到了  /home/wf/dotF/cfg/nvim/after/syntax/tex.vim
"
    "\ python
        au My_syn Syntax python call Bye_pythoN()

            fun! Bye_pythoN()
                "\ todo 用lua? vimL太丑了!
                let py_byE = {
                            "\ 隐藏行末冒号, 和其他语言长得更像
                             \  '^\s*(if|elif|for|while|def|try|except) .{-}\zs:'   : ''  ,
                                "\ 下面几个, 都形如:
                                "\    '^\s*\zs某某某\ze .{-}:'
                                "\ 或 '^\s*\zs某某某> ?:'
                             "\ ---
                                    \  '^\s*\zsif\ze .{-}:'    : '▷'  ,
                                    \  '^\s*\zselif\ze .{-}:'  : '▶'  ,
                                    \  '^\s*\zselse> ?:'       : '▫'  ,
                             "\ ---
                                    \  '^\s*\zsfor\ze .{-}:'   : '∀'  ,
                                    \  '^\s*\zswhile\ze .{-}:' : '∀'  ,
                             "\ ---
                                    \  '^\s*\zsdef\ze .{-}'    : '£'  ,
                                                "\ \ 没必要像下面这么严格地匹配?
                                                "\ \  '^\s*\zsdef\ze {-}\w+\(' : '£'  ,
                                                "\ \  '^\s*\zsdef\ze {-}\w+\(.{-}\)' : '£'  ,  \ 要是函数跨行,就可能无法conceal
                                    \  '^\s*\zstry> ?:'        : '试'  ,
                                    \  '^\s*\zsexcept\ze .{-}:'  : '异'  ,
                                           "\ exception 异常
                                    \  '^\s*\zsfinally> ?:'    : '总'  ,
                             "\ ---
                              \  '<class>' : 'קּ'  ,
                              "\ 提醒自己 可能用错了
                              \  "\\=\\+"         : '咦',
                              \  "\\=-"          : '咦',
                              \  "\\=\\*"         : '咦',
                              \  "\\=\\/"         : '咦',
                             "\ ---
                              \  "is not none"  : '∃',
                              \  "is none"      : '∄',
                             "\ ---
                              "\ \  "if\\ze.{-} else"        : 'לּ',
                              "\ \  "if .* \\zselse"        : 'כּ',
                             "\ ---
                              \  "<or>"         : '或',
                              \  "<and>"        : '且',
                        \}
                        "\ python里的rST在下面处理
                        "\ \  '<os\.path\.join'    :'𝔍' ,




                for [r,c] in items(py_byE)
                    call Match_xX(r, c)
                endfor

                "\ 处理python里的rST:
                    syn match  pyMeth   #:meth:#  conceal contained containedin=pyQuotes_3x2
                    "\ syn match  rstTilde   #:meth:`\zs\~#  conceal
                    "\ 还得是matchadd来暴力封印
                    call matchadd('Conceal', '\v:\w+:`\zs\~', 100, -1, {'conceal':''})
                    call matchadd('Conceal', ':param', 100, -1, {'conceal':''})

                    syn region  rstDouble_BackTick  concealends matchgroup=conceal  start=/``/ end=/``/
                    hi link rstDouble_BackTick String

                call matchadd('Conceal', '\vhelp\=''.{-}$', 100, -1, {'conceal':''})
                call matchadd('Conceal', '\vhelp\=".{-}$', 100, -1, {'conceal':''})
                "\ call matchadd('Conceal', '\vhelp\=''.{-}''', 100, -1, {'conceal':''})

            endf

        "\ au My_syn BufEnter  */Man/py_help/*.pyh  3sleep | call New_py_help()
        au My_syn BufEnter  */Man/py_help/*.pyh  nno si <cmd>call New_py_help()<cr>gg
            "\ fun! New_py_help()
            "\     let last_line =  'wf_py_help'
            "\     if getline(line('$')) != last_line
            "\         silent % sub @^ \+\zs| @  @ge
            "\         silent % sub @\v^\s{6}\ze\p@        @ge
            "\                                  "\ 8个空格, 方便fold
            "\         call setline(line('$')+1, last_line)
            "\     en
            "\ endf
            "\
        au My_syn BufNewFile  */Man/py_help/*.pyh  1sleep | call New_py_help()
        "\ 有bug
        "\ 手动敲si吧
            fun! New_py_help()
                silent % sub @^ \+\zs| @  @ge
                silent % sub @\v^\s{6}\ze\p@        @ge
            "\ "\                              "\ 8个空格, 方便fold
            endf
            "\
            "\
        "\ rst和(经常含rst的)python
        "还是放回after/syntax/rst.vim吧, python里好像复杂些
        "\ au My_syn Syntax python call Bye_rst_py()
            "\ fun! Bye_rst_py()
            "\     syn match  rstMeth   #:meth:#  conceal
            "\     "\ syn match  rstTilde   #:meth:`\zs\~#  conceal
            "\     "\ 还得是matchadd来暴力封印
            "\     call matchadd('Conceal', ':meth:`\zs\~', 100, -1, {'conceal':''})
            "\     if &ft == 'rst'
            "\         call matchadd('Conceal', '\*\*', 100, -1, {'conceal':''})
            "\     en
            "\
            "\     syn region  rstDouble_BackTick
            "\         \ concealends
            "\         \ matchgroup=conceal
            "\         \ start=#``#
            "\         \ end=#``#
            "\     hi link rstDouble_BackTick String
            "\     "\ syn region  rstDouble_BackTick  concealends   start=#``# end=#``#
            "\     "\ syn region  rstDouble_BackTick concealends matchgroup=conceal  start=#``# end=#``#
            "\     "\ conceal contained containedin=rstInlineLiteral
            "\     "\ syn match  rstDouble_BackTick   #``#  conceal contained containedin=rstCruft
            "\ endf


    "\ undotree
    au My_syn Syntax undotree call Bye_undotree()
        fun! Bye_undotree()

            "\ very magic, 在这里反而有点误事, 但懒得改Match_xX了
            let undotree_byE = {
                    \ '\>\ze\d+\<' : ' '  ,
                    \ '\>\d+\zs\<' : ' ' ,
                    \
                    \ '\[\ze\d+]'    : ' ' ,
                    \ '\[\d+\zs]' : ' '  ,
                    \
                    \ '\{\ze\d+}'    : ' ' ,
                    \ '\{\d+\zs}' : ' '  ,
                    \}

            for [r,c] in items(undotree_byE)  | call Match_xX(r, c)  | endfor
        endf


    " zsh
    au My_syn Syntax sh  set syntax=zsh
    au My_syn Syntax bash  set syntax=zsh
    "\ 这会导致反复调用  /home/wf/dotF/cfg/nvim/syntax/sh.vim ?

    au My_syn Syntax zsh call Bye_zsH()
         fun! Bye_zsH()
             let zsh_byE = {
                         \  '^\s*\zsif>'                 : '▷' ,
                         \  '^\s*\zselif>'               : '▶' ,
                         \  '^\s*\zselse>'               : '▫' ,
                         \  '^\s*\zsfi>'                 : '◁' ,
                         \  '; +then'                 : '·' ,
                         \
                         "\ \  '^\s*\zsfor>\ze.{-}in'       : '∀' ,
                         \  '^\s*\zsdone>'               : '↥' ,
                         \
                         \  '[^ ]\zs\=\ze[^ ]'           : '←' ,
                         \  '\zsnn \ze\w{-}[^ ]\=[^ ]' : ''  ,
                         \  'local\ze:'                     :'𝕃' ,
                         "\ \  'nn \w{-}\zs\=\ze[^ ]'   :''  ,
                       \}


             for [r,c] in items(zsh_byE)
                 call Match_xX(r, c)
             endfor

             au My_syn Syntax
                       \ zsh
                       \ call matchadd(
                                        \ 'Conceal',
                                        \ '\v^\s*\zsif>',
                                        \ 99,
                                        \ -1,
                                        \ {'conceal':'▸'},
                                    \ )

         endf

    " skim的终端(浮窗)
    au My_syn Syntax skim  set syntax=wf_term

    "\ c language
    au My_syn Syntax c,cpp call Bye_c()
         fun! Bye_c()
            "\ 不生效:
             let c_byE = {
                         \  '^\s*\zsif>'                 : '▷' ,
                         \  '^\s*\zselif>'               : '▶' ,
                         \  '^\s*\zselse>'               : '▫' ,
                         \  '^\s*\zsfi>'                 : '◁' ,
                         \  '; +then'                 : '·' ,
                         \
                         "\ \  '^\s*\zsfor>\ze.{-}in'       : '∀' ,
                         \  '^\s*\zsdone>'               : '↥' ,
                         \
                         \  '[^ ]\zs\=\ze[^ ]'           : '←' ,
                         \  'local\ze:'                     :'𝕃' ,
                         \  '->'                     : '.' ,
                         "\ \  'nn \w{-}\zs\=\ze[^ ]'   :''  ,
                       \}

             for [r,c] in items(c_byE)
                 call Match_xX(r, c)
             endfor

             au My_syn Syntax
                       \ c,cpp
                       \ call matchadd(
                                        \ 'Conceal',
                                        \ '->',
                                        \ 99,
                                        \ -1,
                                        \ {'conceal' : '.'},
                                    \ )
                       \| call matchadd(
                                        \ 'Conceal',
                                        \ '\/\* ',
                                        \ 99,
                                        \ -1,
                                        \ {'conceal' : ''},
                                    \ )
                       \| call matchadd(
                                        \ 'Conceal',
                                        \ ';$',
                                        \ 99,
                                        \ -1,
                                        \ {'conceal' : ''},
                                    \ )
         endf

    au My_syn Syntax markdown call Bye_markdown()
        "\ 无效:
            "\ syn match markdown_Bye  #[_# contained containedin=markdownBoldThem
            "\ syn match markdown_Bye  #_]# contained containedin=markdownBoldThem
            "\ syn region  markdownBoldThem matchgroup=markdown_Bye  start=#[_#  end=#_]#  concealends oneline

        fun! Bye_markdown()
            let markdown_bye = {
                    \  '^\s*\zsif>'     :  '▷'  ,
                    \}
            for [r,c] in items(markdown_bye)
                call Match_xX(r, c)
            endfor

            call matchadd('Conceal', '{{< \?\w\+ text="\ze\w\+\" term_id="\(\w\|-\)\+" \?>}}', 100, -1, {'conceal':''})
            call matchadd('Conceal', '{{< \?\w\+ text="\w\+\zs" term_id="\(\w\|-\)\+" \?>}}', 100, -1, {'conceal':''})
            "\ call matchadd('Conceal', '```', 100, -1, {'conceal':''})

            "\ 处理这种:
                "\ scheduling refers to making sure that {{<glossary_tooltip text="Pods" term_id="pod">}} are matched to {{<glossary_tooltip text="Nodes" term_id="node">}} so that
                    "\ 不行:
                        "\ \  '\{\{\<\p\+ text="\ze\w\+" term_id="\p\+"\>\}\}'        : '',
                        "\ \  '{{<\p\+ text="\w\+\zs" term_id="\p\+">}}'        : '',

                    "\ syn match In_curly_In_brace    @{{<\p\+ text="\ze\w\+" term_id="\p\+">}}@  conceal
                    "\ syn match In_curly_In_brace    @{{<\p\+ text="\w\+\ze" term_id="\p\+">}}@  conceal



        endf


    au My_syn Syntax html call Bye_html()
         fun! Bye_html()
             let html_byE = {
                      \  '\<li>': '-' ,
                                 "\ 为啥会出现2个ccahr
                      \  '&amp;': '&' ,
                       \}

             for [r,c] in items(html_byE)
                 call Match_xX(r, c)
             endfor
         endf

    au My_syn Syntax autohotkey call Bye_autohotkey()
         fun! Bye_autohotkey()
             let autohotkey_byE = {
                              \  ':\=': '←' ,
                              \}

             for [r,c] in items(autohotkey_byE)
                 call Match_xX(r, c)
             endfor
         endf



    au My_syn  Syntax   lua  call Bye_lua()
        fun! Bye_lua()
            let lua_byE = {
                    \ '<end>'         :  '◁' ,
                    \ 'if.{-}\zs<then>'  :  ''  ,
                    \}

            for [r,c] in items(lua_byE)  | call Match_xX(r, c)  | endfor
        endf
"
"
"
func! g:Hi_paiR()
    syn cluster In_fancY     contains=In_QuestionMark,
                                 \In_AcutE,
                                 \In_Underline,
                                 \In_BackticK,
                                 \In_2BackticK,
                                 \In_StrikE

                            "\ 这导致comment里太多高亮:
                                 "\ \In_Double_QuotE,
                                 "\ \In_Single_quotE

      "   cluster不能用这个argument:   containedin=pythonRawString


    hi In_QuestionMark guibg=#d0e0da
        syn match In_QuestionMark   "\v¿[^¿]+¿"hs=s+1,he=e-1  contains=VictoR containedin=mdCode
                                                                        " containedin=all  "  导致包裹区域被conceal
        syn match VictoR     "¿"  contained  conceal


    " au My_syn BufReadPost * if expand('%:p')  !=  '/home/wf/dotF/cfg/nvim/conceal_fast.vim'
    "                 \ | setl modifiable
    "                 \ | % sub  #¿#¿#ge
    "                 \ | call histdel('search',-2,)
    "                 \ | endif
                        " coc设置时 会报错,  它在搞鬼:
                        " 忽略即可
                                    " coc_nvim  BufEnter
                                    "     *         call s:Autocmd('BufEnter', +expand('<abuf>'))
                                    "     Last set from ~/PL/coc/plugin/coc.vim line 338




    hi In_AcutE guibg=#d0e0da
        syn match In_AcutE     contains=AcutE      "\v´[^´]+´"hs=s+1,he=e-1
        syn match In_AcutE     contains=AcutE     "\v(^|[^a-z\"[])\zs´[^´]+´"hs=s+1,he=e-1
        syn match In_AcutE     contains=AcutE      "\(^\|[^a-z"[]\)\zs´[^´]\+´\ze\([^a-z\t."']\|$\)"hs=s+1,he=e-1

        syn match AcutE     "´" contained  conceal
            " echom 'acute______________'  能echom, 但为啥不生效?

        "\ call matchadd('leoHight', '`[^` \t]\+', 1, -1, {"conceal":1} )
        " 用作method为啥不行?
        "  leoHight->matchadd('`[^` \t]\+')
        " 没加let吧?
        "

    hi In_Underline guifg=none gui=underline
        syn match In_Underline   contains=Exclam_up_down    "\v \zs¡[-_a-zA-Z0-9'"*+/:%#=[\]<>.,]+¡"
                                                             " ¡包裹的
        syn match Exclam_up_down   '¡' contained conceal

    "\ 不生效, 这个特殊字符 自带颜色?
    hi  A_strikE   guifg=#fbbbbb
        syn match A_strikE    '✗'

    " hi  In_StrikE  ✗gui=italic,inverse✗ guifg=gray  guibg=none
    hi  In_StrikE  gui=none guifg=#bbbbbb  guibg=none
        syn match In_StrikE "\v✗[^✗]+✗"  contains=StrikE
        syn match StrikE      '✗'        contained      conceal
                          " 输入: ctrl-k Y-


    "\ quote
        hi In_Double_quotE guifg=#af5f00 guibg=#eeeee0 gui=none
        syn match Double_quotE   @"@ contained conceal         containedin=In_Double_quotE
        syn match In_Double_quotE      '\v(^|\W)\zs"[^"]{1,80}"'
                                \ containedin=vimStr,pyStr

        "\ syn region In_Double_quotE   start=@ \zs"@  end=@"\ze @
        "\                         \ oneline
        "\                         \ concealends
        "\                         \ matchgroup=Double_quotE
        "\                         \ containedin=vimStr,pyStr
            "\ 淘汰了:
                "\ syn match Double_quotE   #"\v"@<!# contained conceal         containedin=In_Double_quotE
                "\                         "\ 双引号后 如果紧贴双引号, 则为Empty_stR
                "\ "\ syn match Double_quotE   '"' contained conceal cchar=  containedin=vimStr
                "\     hi In_Double_quotE guifg=#af5f00 guibg=#eeeee0 gui=none
                "\     syn match In_Double_quotE      '\v \zs"[^"]{1,80}"'
                "\                               \ containedin=vimStr,pyStr
                "\                               "\ \ transparent
                "\                                       "\ 要手动加每种语言吗zshStr..
                "\
                "\     " hi In_Double_quotE_short guifg=#903a9a gui=none
                "\     "     " 太短 所以颜色要明显一些 不然看不出来  "     算了 长的也明显些吧
                "\     "     syn match In_Double_quotE_short   contains=Double_quotE    '\v^\s*[^:]{-}\zs"[^"]{1,6}"'
                "\                                                           " not end with star

        syn match Single_quotE   @'@  contained   containedin=vimStr     conceal
            "\ syn match Single_quotE   #'\v'@<!#  contained   containedin=vimStr conceal
                                    "\ 单引号后 如果紧贴单引号, 则为Empty_stR
            "\ syn match Single_quotE   #'# containedin=vimStr contained cchar=  conceal
                                        "\ containedin=String  " 没有String这个syntax group, 它只是highlight group  \ containedin=PyStr  " 不行

    syn match Space_stR   #'\s\+'#  contains=Single_quotE  containedin=vimStr,@vimCmts
    syn match Space_stR   #"\s\+"#  contains=Double_quotE  containedin=vimStr,@vimCmts
    hi  link Space_stR    In_QuestionMark

    "\ in quote
        hi In_Single_quotE guifg=#508a9a gui=none
            " syn match In_Single_quotE   contains=Single_quotE    #\v \zs'[^']{3,80}'#
            syn match In_Single_quotE   contains=Single_quotE
                                      \ #\v%(^|\W)\zs'[^']{3,80}'#


        hi link Short_optioN In_Single_quotE
            syn match Short_optioN      contains=Single_quotE    #'-\a'#  " python的命令行的-a -h等选项
        hi link RHS_of_equatioN In_Single_quotE
            syn match RHS_of_equatioN   contains=Single_quotE    #\v\= ?\zs'\k+'#  " python的命令行的-a -h等选项

        hi Single_quote_shorT guifg=#508a9a gui=none guibg=#e0e6e3
            syn match Single_quote_shorT    contains=Single_quotE    #\v \zs'[^']{1,2}'#

    "\ empty str
    "\ 要在In_某某_quotE后面, 不然引号完全看不见
        "\ syn match Empty_stR   # \zs''\ze #   containedin=vimStr,@vimCmts
        "\ syn match Empty_stR   # \zs""\ze #   containedin=vimStr,@vimCmts

        "\ syn match Empty_stR   #""#   containedin=vimStr,@vimCmts       "\ python的docstring的开头 被当作Empty_stR:
        syn match Empty_stR   #\v"@<!""#   containedin=vimStr,@vimCmts
                            "\ 匹配左侧没有¿"¿的¿""¿
        syn match Empty_stR   #\v'@<!''#   containedin=vimStr,@vimCmts
        "\ syn match Empty_stR   #\v'@<!''\ze( |,)#   containedin=vimStr,@vimCmts

        hi  link  Empty_stR Normal
        "\ todo: python里的空串 现在被conceal了 没有highlight
        "\ call matchadd('In_BackticK', '""\@<!"', 100)
    "

    hi In_BackticK guifg=#00000 guibg=#e8e9db gui=none
        " hi In_BackticK guifg=#00000 guibg=#fdf0e3 gui=none
        "\ hi In_BackticK guifg=#00000 guibg=#e0e0df gui=none

                                                            " 不高亮两头的backtick
        syn match In_BackticK     contains=BackTick,In_QuestionMark     @`[^` \t]\+`@
                                                                     \hs=s+1
                                                                    \,he=e-1
        syn match In_BackticK     contains=BackTick,In_QuestionMark     @\v \zs(^|[^a-z\"[])\zs`[^`]+`@
                                                                                    \hs=s+1
                                                                                   \,he=e-1
        syn match In_BackticK     contains=BackTick,In_QuestionMark     @\(^\|[^a-z"[]\)\zs`[^`]\+`\ze\([^a-z\t."']\|$\)@
                                                                                    \hs=s+1
                                                                                   \,he=e-1
            " 貌似不能用 /变量/hs....
                "\ let str_HI = "\v(^|[^a-z\"[])\zs" .. "`[^`]+`"
                "\ let str_HI = "\v(^|[^a-z\"[])\zs" .. "`[^`]+`" .. "\ze([^a-z\t\"']|$)"
                " syn match In_BackticK     contains=BackTick  /str_HI/hs=s+1,he=e-1
                "
        " hi  BackTick guifg=#fdf6e3  gui=none guibg=none
        syn match BackTick   "`"   contained conceal

    hi link Backtick_quotE In_backticK

        syn match Backtick_quotE  contains=BackTick,Single_quotE     @`[^`']\+'@hs=s+1,he=e-1
        "\ syn  match  Backtick_before_quote        /`/  conceal  contained  containedin=Backtick_quotE
        "\ syn  match  Single_quote_after_backtick  /'/  conceal  contained  containedin=Backtick_quotE

    hi In_2BackticK guifg=#00000 guibg=#e8e9db gui=none

        syn match In_2BackticK     contains=BackTick,In_QuestionMark  "``[^` \t]\+``"hs=s+1,he=e-1
                                                                " 不高亮两头的backtick
        syn match In_2BackticK     contains=BackTick,In_QuestionMark  "\v \zs(^|[^a-z\"[])\zs``[^`]+``"hs=s+1,he=e-1
        syn match In_2BackticK     contains=BackTick,In_QuestionMark  "\(^\|[^a-z"[]\)\zs``[^`]\+``\ze\([^a-z\t."']\|$\)"hs=s+1,he=e-1
        syn match BackTick   "``"   contained conceal


endf

fun! g:Hi_markuP()
    syn match Empty_conceaL
                \ #\v \zs(an )?empty( string)?#
                \ conceal
                \ cchar=ױ

    syn match When2iF
                \ #\v^\s*\zsWhen>#
                \ conceal
                \ containedin=ALL
                \ cchar=▷

    " 如果要用, 再加这行, (别在python里conceal square bracket, it does not mean optional):
        " syn cluster Markup_fancY   contains=In_QuestionMark,In_AcutE,In_Underline,In_SquarE,Short_hand

         " syntax match v_Line_Cmt   /^[ \t:]*".*$/  contains=@vimCmts,vimCmt_Str,vimCmt_Title
         " 这样comment就和正文混一起了.. .

    hi man_QuotE  guifg=#903a9a gui=none
        syn match man_QuotE
               \ contains=BackTick,Single_quotE
               \ #\v zs``?.[^`']{1,80}'?'#
                        "   ``''
                        "   或
                        "   `'
    " todo: 生效没?
        " au My_syn Syntax   md,markdown
            "\ \   syn match VictoR    "¿"  contained  conceal  containedin=mdNonListItemBlock
            "\ \ | syn match Md_beautifY contains=VictoR      "\v¿[^¿]+¿"hs=s+1,he=e-1
        "                                 \ contained  conceal containedin=mdNonListItemBlock



    syn match BaR    "|"  contained conceal
        hi  In_BaR  guifg=#206043                         " 能匹配好多东西
            syn match In_BaR        contains=BaR  "\v\\@<!\|[!#-)+-~]+\|"
            "\ syn match In_Bar_enD    contains=BaR  "\v^\p{-}  \\@<!\|[!#-)+-~]+\|$" conceal
                                                     " 与前面隔开2个空格, 且位于行末,
                                                     " \\@<!  ¿@<!¿ 使得后续内容 的前面不能有¿\¿
                                                    "\ ^\p{-} 如果|xxx|单独成行, 不被封印
            " syn match In_BaR        contains=BaR  "\v\\@<!\|[!#-)+-~]+\|"  conceal
                                                                         " 只在markup language里conceal
                                                                         " 啊 会导致有些行内的内容不见了
                                                      " ! 双引号是34  # $ % & ' (  )  42是星号   +  ~
                                                      " 33           35            41           43 126

    syn match Bar_with_lnuM    "|"  contained
        hi  Bar_with_lnuM guifg=#f0f0e0

                    "\ |3 col 10 info|
        hi  Toc_lnum guifg=#f0f0e0
        syn match Toc_lnum   "\v\\@<!\|\s{,4}\d{1,5}\| " contains=Bar_with_lnuM  conceal
                                                          " toc的行号
        "
        " 这使得竖线不是被隐藏, 而是和背景一样的颜色, 看不见,(但还占着位置,不会少一个字符位置)
            " 代替了:
            " syn match BaR    "|"  contained  conceal    |  hi def  BaR gui=underline
                                                               " conceal后, hi def BaR 被覆盖
                                    " contained让竖\1线不会被单独匹配
                                                  " conceal作为一个flag, 让竖线(bar)在被匹配时, 会被conceal
            " hi def  BaR  guibg=#ff0000
            " 1.  有hi def link
            "   但hi def 某个颜色 很少见, 如果用了,
            "   得先hi clear再hi def不生效
            "
            " 2. hi  BaR guifg=bg_wf
            "    在leo_light.vim里 guifg=bg_wf 明明可以, 这里却不生效(但不报错)

                " 这是为了排除掉包含bar的这几种情况?
                    syn match helpNormal                "|.*====*|"
                    syn match helpNormal                "|||"
                    syn match helpNormal                ":|vim:|"       " for :help modeline

        hi In_SquarE guifg=#b0b0b0
            syn match In_SquarE     contains=left_squarE,righ_squarE  "\v\s\[[-a-zA-Z0-9_]+]"
                syn match left_squarE        "\["  contained conceal
                syn match righ_squarE         "]"  contained conceal
                " help.vim里有可以匹配[count]等的这个:
                "   syn match helpSpecial         "\v\s\[[-a-z^A-Z0-9_]{2,}]"ms=s+1
                "   所以In_SquarE被helpSpecial覆盖了?

          " 处理缩写,比如 b[uffer]
          hi Short_hand guifg=#b0b0b0
              syn match Short_hand    contains=left_squarE,righ_squarE "\v\w\zs\[(\w+|!)\]"
                  " g[lobal]里面的中括号, 表示缩写,不表示option,
                  " 不在helpOptional这个组里
                  " 我用正则 可以匹配g[lobal]


    " au My_syn Syntax * echom 'afile:'  expand('<afile>:p') | echom ' '
    " au My_syn Syntax * echom 'amatch:' expand('<amatch>:p') | echom ' '
    "                                      " amatch显示~/dotF/cfg/nvim下的文件(扔掉.vim)

    " :help syntax-loading
        "   Any other user installed FileType or Syntax autocommands are triggered.
        "   This can be used to change the highlighting for a specific syntax.
endf

"
au My_syn Syntax   *                        call Hi_paiR()
au My_syn Syntax   help,man,nroff,w3m       call Hi_markuP()
"\ au My_syn Syntax   help,man,nroff,w3m,tex   call Hi_markuP()

au My_syn Syntax   vim,help,lua    source $nV/after/syntax/vim.vim

"
au My_syn Syntax   * call Few_wordS()
"\ au My_syn FileType *
        "\ 好像不行:
    fun! g:Few_wordS() abort
        syn match FeW  #\v%(less|smaller) than#                       conceal cchar=≺

        syn match FeW  #\v\%(more|bigger|greater)\s+than\ze( or)@!#         conceal cchar=≻

        syn match FeW  #at most#                                                 conceal cchar=≤
        syn match FeW  #\v%(small|less)%(%(-| )?than)? or equal to#        conceal cchar=≤
        "\ syn match FeW  #up to#                                                 conceal cchar=≤
            "\ 别这么设,
                "\ 反面例子:Exactly how an "area" is defined is ¿up to¿ the application developer.

        syn match FeW  #\v(at least|no smaller than)#                        conceal cchar=≥
        syn match FeW  #\v%(greater|more)%(%(-| )?than)? or equal to#        conceal cchar=≥
                                "\ more than 或者more-than
    endf

" au My_syn Syntax   help                     call Hi_helP()
" 放回help.vim里
    " fun! Hi_helP()
    " endf
"
"\ comment delimiters
    "\ 不生效:
        "\ au My_syn Syntax   c     syn match js_com_delI '\/\* '
        "\                                     \ contained  containedin=cCommentString conceal
        "\
        "\ au My_syn Syntax   c     syn match js_com_delI ' \*\/'
        "\                                     \ contained  containedin=cCommentString  conceal

    au My_syn Syntax   tmux     syn match tmux_com_delI '# '
                                        \ contained  containedin=tmuxComment conceal

    au My_syn Syntax   javascript     syn match js_com_delI '\/\/ '
                                        \ contained  containedin=jsLineComment conceal

    au My_syn Syntax   scheme     syn match scheme_com_delI '; '
                                        \ contained  containedin=schemeComment conceal



        "\ au My_syn Syntax   python       syn match pyCmt_delI '\v\zs# = =\ze\p'   contained  containedin=pyComment  conceal
        "\ au My_syn Syntax   python       syn match pyCmt_delI '# *$'          contained  containedin=pyComment  conceal  "
                                                            " 处理一行里只有井号的情况
                "\ 放在文件里也不行: /home/wf/dotF/cfg/nvim/syntax/python.vim


    au My_syn Syntax   c          syn match c_com_delI '\/\/ '
                                        \ contained  containedin=cCommentL conceal

    au My_syn Syntax   c          syn match c_com_delI2 '\/\/\/ '
                                        \ contained  containedin=cCommentL conceal

    au My_syn Syntax   snippets
        \   syn match snippets_com_delI '^#$' conceal
        \ | syn match snippets_com_delI '^# '
              \ contained conceal containedin=snippetsComment,snipmateComment
        \ | hi link snippets_com_delI Vim_com_delI

    au My_syn Syntax   conf     syn match conf_com_delI '\v%(^|\s+)\zs#%( |$)'
        \ contained conceal containedin=confComment
        \ | hi link conf_com_delI Vim_com_delI

    au My_syn Syntax   sshconfig     syn match sshconfig_com_delI '\v%(^|\s+)\zs#%( |$)'
        \ contained conceal containedin=sshconfigComment
        \ | hi link sshconfig_com_delI Vim_com_delI


    "\ 不生效,why?
    au My_syn Syntax   gitconfig     syn match gitconfig_com_delI '[#;] '
        \ contained conceal containedin=gitconfigComment
        \ | hi link gitconfig_com_delI Vim_com_delI

    au My_syn Syntax   zsh     syn match Zsh_com_delI '\v#%( |$)'
        \ contained conceal containedin=zshComment
        \ | hi link Zsh_com_delI Vim_com_delI

    au My_syn Syntax   dockerfile     syn match dockerfile_com_delI  '^\s*#'
        \ contained conceal containedin=dockerfileComment
        \ | hi link dockerfile_com_delI Vim_com_delI

    au My_syn Syntax   gitignore     syn match gitignore_com_delI  '^# '
        \ contained conceal containedin=gitignoreComment
        \ | hi link gitignore_com_delI Vim_com_delI



    "\ au My_syn Syntax   toml     syn match Toml_com_delI '\v%(^|\s+)\zs#%( |$)'
                                                        "\ 有缩进的#无法封印
    au My_syn Syntax   toml     syn match Toml_com_delI '\v# '
        \ contained conceal containedin=tomlComment
        \ | hi link Toml_com_delI Vim_com_delI

    au My_syn Syntax   yaml     syn match yaml_com_delI '\v# ?'
        \ contained conceal containedin=yamlComment
        \ | hi link yaml_com_delI Vim_com_delI


    au My_syn Syntax   ps1     syn match ps1_com_delI '\v# '
        \ contained conceal containedin=ps1Comment
        \ | hi link ps1_com_delI Vim_com_delI


    au My_syn Syntax   autohotkey     syn match autohotkey_com_delI  '\v%(^|\s+)\zs;%( |$)'
        \ contained conceal containedin=autohotkeyComment
        \ | hi link autohotkey_com_delI   Vim_com_delI

    " hi link Fold_marK HidE
        au My_syn Syntax   *   syn match Fold_marK  #"\s*{{{\d\?$# conceal containedin=@vimCmts
        au My_syn Syntax   *   syn match Fold_marK  #"\s*}}}\d\?$# conceal containedin=@vimCmts


" ref:
    " if !has('conceal')
    "     finish
    " endif
    "
    " syntax clear cppOperator
    "
    " syntax match cppOperator "<=" conceal cchar=≤
    " syntax match cppOperator ">=" conceal cchar=≥
    "
    " syntax match cppOperator "=\@<!===\@!" conceal cchar=≡
    " syntax match cppOperator "!=" conceal cchar=≢
    "
    " syntax match cppOperator "\<or\>" conceal cchar=∨
    " syntax match cppOperator "\<and\>" conceal cchar=∧
    " syntax match cppOperator "\<not\>" conceal cchar=¬
    "
    " syntax match cppOperator "::" conceal cchar=∷
    " syntax match cppOperator "++" conceal cchar=⧺
    "
    " syntax match cppOperator "\<pi\>" conceal cchar=π
    " syntax match cppOperator "\<sqrt\>" conceal cchar=√
    "
    " syntax match cppOperator ">>" conceal cchar=»
    " syntax match cppOperator "<<" conceal cchar=«
    "
    " syntax keyword cppOperator NULL conceal cchar=⊥
    " syntax keyword cppOperator nullptr conceal cchar=⊥
    "
    " syntax keyword cppOperator bool conceal cchar=𝔹
    " syntax keyword cppOperator int conceal cchar=ℤ
    " syntax keyword cppOperator float conceal cchar=ℜ
    "
    " syntax match cppOperator "\<length\>" conceal cchar=ₗ
    " syntax match cppOperator "\<size\>" conceal cchar=ₛ
    "
    " syntax match cppOperator "\<array\>" conceal cchar=𝒜
    " syntax match cppOperator "\<list\>" conceal cchar=ℒ
    "
    " syntax keyword cppOperator void conceal cchar=⊥
    "
    " syntax keyword cppOperator false conceal cchar=𝐅
    "
    " syntax keyword cppOperator true conceal cchar=𝐓
    "
    "
    "
    " syntax keyword cppOperator function conceal cchar=λ
    " syntax keyword cppOperator return conceal cchar=↵
    "
    " hi link cppOperator Operator
    " hi! link Conceal Operator
    "
    " setl     conceallevel=1
    "
    "
    "
" ref:
    " setl     conceallevel=1
    " syntax clear cppOperator
    "
        " syntax match cppOperator "++" conceal cchar=⧺
        " syntax match cppOperator "=\@<!===\@!" conceal cchar=≖
        " syntax match cppOperator "!=" conceal cchar=≠
        " syntax match cppOperator "<=" conceal cchar=≤
        " syntax match cppOperator ">=" conceal cchar=≥
        "
        " syntax match cppOperator "<<" conceal cchar=«
        " syntax match cppOperator ">>" conceal cchar=»
        "
        " syntax match cppOperator "::" conceal cchar=∷
        " syntax match cppOperator "->" conceal cchar=→
        "
        " syntax match cppOperator "||" conceal cchar=∥
    "

