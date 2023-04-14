" buffers
    set hidden
    " If you want to keep the changed buffer (让vim记住它) without saving it(写到文件), switch on the
    " 'hidden' option.
    " nnoremap gb :bnext<CR>
    nno  gB :bprev<CR>



" tab
    " 导致卡死
    " au AG TabEnter * tabmove 0
    " au AG BufEnter * tabmove 0

    " normal模式下切换到确切的tab
        no  <leader>1 1gt
        no  <leader>2 2gt
        no  <leader>3 3gt
        no  <leader>4 4gt
        no  <leader>5 5gt
        no  <leader>6 6gt
        no  <leader>7 7gt
        no  <leader>8 8gt
        no  <leader>9 9gt

    " Toggles between the active and last active tab
        let g:last_active_TaB = 1
            " 只有一个tab时, 自然要取1
        nno <silent> <leader>t <Cmd>execute 'tabnext'  g:last_active_TaB<cr>
        vno <silent> <leader>t <Cmd>execute 'tabnext'  g:last_active_TaB<cr>
        au AG TabLeave * let g:last_active_TaB = tabpagenr()
        " tabpagenr(): 当前tab的序号

        set tabpagemax=12

        set switchbuf=usetab,newtab

" tabline:
    "\ todo: When files with the same filename belonging to different directories are opened simultaneously,
            "you can include a unique filetree prefix to distinguish between them:
    "\ https://github.com/noib3/nvim-cokeline

    set showtabline=2
        " 1: only if there are at least two tab pages
        " 2: always


    func! Wf_tabline()

        "\ color
            hi TabLine          guibg=#e0e5e3  gui=none    guifg=#123456
            hi TabLineWins      guibg=#c9c9c9  gui=none    guifg=#123457

            hi TabLineSel       guibg=#e0f6e3  gui=bold    guifg=#123456
            "\ hi TabLineSel_wins  guibg=#e0f6e3  gui=bold    guifg=#123456

            hi TabLineFill      guibg=#e0e5e3  gui=none    guifg=#e4e0e0

            "\ 下面的highlight group是我定义的
            hi tabIcon         guibg=#e0e5e3  gui=bold    guifg=#2f90b0
            hi tabIcon_Sel     guibg=#e0f6e3  gui=bold    guifg=#2f90b0

            hi tabModified     guibg=#e0e5e3  gui=none    guifg=#0aafbb

            hi tabSeparate       guibg=#e0e5e3     gui=bold    guifg=#00aaaa
            hi tabInnerSeparate  guibg=#e0e5e3  gui=none    guifg=#012345

        let tabs_as_line = ''
        let char_between_wins = ' ¦'
        for tab_id in range( 1, tabpagenr('$')  )  "\ range(闭区间开头, 闭区间结束)  和python不同
                             " 第一个tab是1,而非0

            let n_win_in_tab = tabpagewinnr(tab_id, '$')
            let m_TOC_in_tab = 0

            let a_tab = ''
                "\ todo
                "\ 从记录所有tab的buf的列表里, 删掉quickfix等无名buf (常用于Table of Content)

            for winnr_in_tab in range(1, n_win_in_tab )
                if winnr_in_tab < 2
                    let a_win = ''
                else
                    let a_win = char_between_wins
                endif
                let this_bufnr = tabpagebuflist(tab_id)[ winnr_in_tab - 1 ]


                let PwD  =  getcwd(winnr_in_tab,  tab_id)  "\

                let long_bufname = expand("#" . this_bufnr . ":p")
                                    "\ #:  alternate file name
                let is_toc = 0
                if  long_bufname =~ "term:"
                            " 形如:term://~/dotF/cfg/nvim//809801:zsh
                            " =~   regexp matches (zsh里也是这样 不是~=, python里用regular模块吧 )
                            "      =~ 后, patter永远是magic的
                            " !~   regexp doesn't match

                    "\ let PwD = substitute(getcwd(-1, tab_id-1)     , '^term://' , '' , '')
                    "\ let PwD = substitute(PwD          , '//\d\+:.*', '' , '')
                    "\ let a_list = split(PwD, '/')[-2:-1]

                    let a_list = split(PwD, '/')[-2:-1]
                    for _idx in range(len(a_list))
                        if len(a_list[_idx]) > 4
                            "\ let a_list[_idx] = a_list[_idx][:3] . '·'  \ 如果遇到中间有中文, 可能在双字节中间切开
                            let a_list[_idx] = a_list[_idx][:6] . '·'
                                                            "\ 行中间点号
                        en
                    endfor
                    let PwD = join(a_list , '/')
                    let a_win .=  PwD
                    "\ let a_win .=  split(b:term_title, ' ')[0]  \ 导致many errors, because if the current buffer is not a
                            "\ term buffer, it can not access other buffer's b:term_title
                    let a_win .=  ' '

                elseif  long_bufname == ''
                    if getbufvar( this_bufnr, '&buftype' ) == 'quickfix'
                        let title_of_qf = gettabwinvar( tab_id, winnr_in_tab, 'quickfix_title' , '没title的qf'  )[:10]
                        if title_of_qf !~ 'toc'
                            let a_win .=  title_of_qf
                        else
                            let is_toc = 1
                            let m_TOC_in_tab += 1
                            "\ let a_win =  substitute(
                            "\                   \ a_win,
                            "\                   \  '\v¦ ([^¦])$',
                            "\                   \ '\1',
                            "\                   \ '',
                            "\                  \ )
                            "\                       "\ char_between_wins 放这里, 方便搜特殊字符
                        endif

                        "\ let a_win .=  getbufvar( this_bufnr, 'quickfix_title' , '没title的qf'  )[:10]
                                  "\ getbufvar无法获取w:XXXX
                    el
                        if tabpagewinnr(tab_id, '$') == 1
                            let a_win .=  '|·|'
                            "\ let a_win .=  '···'
                            "\ let a_win .=  '[No Name'

                        el  "\ 一个tab里有多个window时 这种buf的名字不显示
                            let a_win = ''
                        en
                    en
                el
                    " 取路径首字母
                    if long_bufname    =~ 'after'    ||
                    \ long_bufname =~ 'plugin'   ||
                    \ long_bufname =~ 'autoload' ||
                    \ long_bufname =~ 'ftplugin' ||
                    \ long_bufname =~ 'syntax'

                        let p_nega_3 = split(long_bufname, '/')[-3][0:4]
                        let p_nega_2 = split(long_bufname, '/')[-2][0:4]

                        let PwD = join([p_nega_3,p_nega_2] , '/')
                        let a_win .=  PwD . '/'
                    en


                    if long_bufname   =~ '\/arxivs\/'
                        let paper_name = split(long_bufname, '/')[-2][0:10]
                                                                " 文件名前10个字符
                        let a_win .=  paper_name . '/'
                    en


                    if long_bufname =~ '\v\p+\.\p+$'  " 形如my_name.suffix

                        let f_namE = fnamemodify(long_bufname, ':t')

                        if f_namE =~ '\v\.\p+$'
                                    " 用双引号, 无法用\a, \p 等 只能 [a-z]
                                        " \p printable
                            if f_namE =~ 'readme'
                                "\ 显示路径  避免多个readme同时打开时 显得乱
                                let PwD  =  getcwd(winnr_in_tab,  tab_id)
                                let repo = split(PwD, '/')[-1]
                                if len(repo) > 4
                                    let repo = repo[:8] . '·'
                                                     "\ 行中间点号
                                en
                                let a_win .=  repo . '/ 📑'
                            else
                                let icon = File_Icon(f_namE)
                                            " parameters: a:1 (filename), a:2 (isDirectory)
                                            " both parameters optional
                                            " by default without parameters uses buffer name

                                if icon == ''
                                    let a_win .= f_namE
                                el
                                    let a_win .= fnamemodify(f_namE, ':r')  " 扔掉最后一个后缀名, 例如 starlette.requests.txt 扔掉.txt
                                    "\ let a_win .= f_namE ->substitute('\v\.\p{2,}$',  ' ',  '')
                                             "\ f_namE ->substitute("\v\.[a-z]",  '',  '')

                                    let a_win .= (tab_id == tabpagenr()
                                                \ ?  '%#tabIcon_Sel#'
                                                \ :  '%#tabIcon#' )
                                    let a_win .=  ' ' . icon
                                            "\ 这里有个thin space  ¿ ¿
                                    let a_win .= (tab_id == tabpagenr()
                                                \ ?  '%#TabLineSel#'
                                                \ :  '%#TabLine#' )
                                en
                            endif
                        el
                            let a_win .= f_namE

                        en

                    el  " 没有后缀名
                        let tail = fnamemodify(long_bufname, ':t')
                        let a_win .=   tail =~ '^\d\+$'
                                    \ ? '[pre]'
                                    \ : tail

                                    "\ pre表示preview?

                        let a_win .=  ' '
                        let a_win .=  File_Icon(long_bufname)
                    en
                en


                let a_win .= getbufvar(this_bufnr, "&modified")
                            \ ?   ( is_toc
                                    \ ?  ' '
                                    \ : ' + '
                                \ )
                            \ :  ' '


                "\ if winnr_in_tab < n_win_in_tab
                "\     let a_win .= char_between_wins
                "\ endif

                let a_tab .= a_win
            endfor

                            " tab page number
            let which_hi = (tab_id == tabpagenr()
                        \ ? '%#TabLineSel#'
                        \ : ( n_win_in_tab - m_TOC_in_tab > 1)
                                \ ? '%#TabLineWins#'
                                \ : '%#TabLine#'
                    \ )
            let tabs_as_line .= which_hi . a_tab  . '%#tabSeparate#|'
        endfor

        let tabs_as_line .= '%#TabLineFill#'

        if exists('g:neovide')
            let short_hostname =  g:wf_hostname != ''
                                \ ? g:wf_hostname
                                \ : hostname()
            return tabs_as_line . '%=' . '%#TabLine#' . strftime('%d号 %H:%M ') . ' | '  . short_hostname . ' '
                      "\ 右对齐
        el
            return tabs_as_line
        en

    endf
    set tabline=%!Wf_tabline()

" statusline
set laststatus=2  "  always show statusline
        " 没有statusline时，命令那行和代码容易混在一起

" Each status line item is of the form: ( All fields except the {item} are optional.)
"       %-0{minwid}.{maxwid}{item}
    " 在上面的基础上：  (几表示某个highlight设置)
    " %Highlight配色号码


    "\ hi   Hi_status_2          guibg=#f5f5e3   guifg=#123456
    hi   Hi_status_2          guibg=#e4e4e4   guifg=#123456
    hi   Hi_status_3          guibg=#efe9d8   guifg=#123456
    hi   Hi_status_light      guibg=#eee9d9   guifg=#029456   gui=bold
    hi   Hi_status_standout   guibg=#e0e6d3   guifg=#000000   gui=bold
        "\ 不再用了?:
            hi User0   guibg=none  guifg=#000000
            hi User1   guibg=none  guifg=#000000
            "\ 貌似不能放进colorscheme file.



    " statusline是个str, 竖线 空格都要escape

    " ¿%几*¿ 表示User几的highlight
    " ¿%#Your_highlight_name#¿ 可用正常的hi group


    " 改stl时 避免看晕:
        " syn match Set_status_linE  #\Vset stl+=#  conceal cchar=•

    set stl=   " 不加这行 会导致reload后stl很多重复
    set stl+=\ " space
    set stl+=%#Hi_status_standout#
    set stl+=%2l
    set stl+=%#StatusLine#
    set stl+=/%L行 " line number
                 " broken bar
    set stl+=,\ %2v\列 " 2表示 至少占2位
    "\ set stl+=\ ¦\ %2v\列 " 2表示 至少占2位
                " v    Virtual column number (screen column).
                " c    Column number (byte index) 2个中文之间差了3, 有点奇怪
    " set stl+=\ %F\ \     " File+path
    set stl+=%#Hi_status_2#
    set stl+=\ %{Status_f_namE()}\ \     " File+path
    fun! Status_f_namE()
        let file_with_icon = ''

        "\ 处理文件名
            let full_name = expand('%:p')

            if full_name =~ 'term://'
                return  ''
            en
            if full_name =~ '\v' . '\p+\.\p+$'  " 有后缀名
                                    " \p printable
                                    " 如果用双引号, 无法用\a, \p 等 只能 [a-z]

                let f_namE = fnamemodify(full_name, ':t')

                if f_namE =~ '\v' . '\.\p+$'
                    let icon = File_Icon(f_namE)
                                " parameters: a:1 (filename), a:2 (isDirectory)
                                " both parameters optional
                                " by default without parameters uses buffer name

                        if icon !=  ''
                            let file_with_icon = fnamemodify(f_namE, ':r') . " "
                            " 去掉最后一个后缀名 淘汰了:

                                    "\ let dot_parts =  split(f_namE, '\.')
                                    "\                             "\ 要escape
                                    "\ let file_with_icon   = join(dot_parts[:-2], '.' ) . ' '
                                    "\                                     "\ 右边是闭区间, 不像python
                                "\ 无法处理有多个¿.¿的文件名:
                                    "\ let file_with_icon .= f_namE ->substitute('\v\.\p{2,}$',  ' ',  '')
                                                    "\ f_namE ->substitute("\v\.[a-z]",  '',  '')


                            "\ 为啥不能像tabline那样?
                            "\ let file_with_icon .=    '%#Hi_status_3#'
                            let file_with_icon .=   icon
                            "\ let file_with_icon .=    '%#Hi_status_3#'

                        el
                            let file_with_icon  .= f_namE
                        en

                el
                    let file_with_icon .= f_namE
                en

            el  " 没有后缀名
                let tail = fnamemodify(full_name, ':t')
                let file_with_icon .=   tail =~ '^\d\+$' ?
                                        \ '[pre]'
                                        \ : tail
                let file_with_icon .=  ' '
                let file_with_icon .=  File_Icon(full_name)
            en

        "\ 避免显示的path太长
            let expand_path = expand('%:p:~:h')
                                    "\ 用~表示home

            if expand_path =~ "/arxivs"
                let pieces = expand_path ->split('/arxivs')
                let folder  = pieces[-1]
                if  folder[0] == '/'
                    let folder = folder[1:]
                en
                let expand_path   = folder  ->substitute('_', ' ','g')
                let expand_path   = expand_path[:40]

            elseif expand_path =~ 'dotF'
                if expand_path == '~/dotF/cfg/nvim'
                    "\ 上面用了expand('%:p:~:h'),这样就不行:
                    "\ if expand_path == 'home/wf/dotF/cfg/nvim'
                    let expand_path   = ''
                elseif expand_path =~ '~/dotF/cfg/nvim/'  "\ 和上面重复? 不, 如果进了 上面的分支 就不会再进来
                    let pieces = expand_path ->split('~/dotF/cfg/nvim/')

                    let path_in_nvim = pieces[-1]
                    if path_in_nvim =~ 'after/'
                        let pieces_2 =  split(path_in_nvim, 'after/')
                        let expand_path   = '后/' . pieces_2[-1]
                    el
                        let expand_path   = '/' . path_in_nvim
                                    "\ victory表示vim
                    en

                el
                    let pieces = expand_path ->split('/dotF/')
                    let expand_path   = '⌂/' . pieces[-1]
                en

            elseif expand_path =~ '~/PL'
                let pieces =  expand_path ->split('~/PL/')
                let expand_path   = '/' . pieces[-1]

            elseif  expand_path =~ '/home/linuxbrew/.linuxbrew/'
                let pieces =  expand_path ->split('/home/linuxbrew/.linuxbrew/')
                "\ let expand_path   = ' ' . pieces[-1]
                let expand_path   = 'צּ/' . pieces[-1]
                                "\ homebrew  酒瓶

            elseif  expand_path =~ '/media/wf/data/large_wf/work/timm/pytorch-image-models/'
                let pieces =  expand_path ->split('/media/wf/data/large_wf/work/timm/pytorch-image-models/')
                "\ let expand_path   = ' ' . pieces[-1]
                let expand_path   = 'IMM/' . pieces[-1]
                                "\ homebrew


            elseif  expand_path =~ '/tT/wf_tex'
                let expand_path   = 'TeX'
                let pieces =  expand_path ->split('/tT/wf_tex/')

                if len(pieces) > 1  | let expand_path  .=  pieces[-1]  | endif

            elseif  expand_path =~ '/\.trash/'
                let pieces =  expand_path ->split('/.trash/')
                let expand_path   = '🗑/' . pieces[-1]

            elseif  expand_path =~ '/\.t/'
                let pieces =  expand_path ->split('/.t/')
                let expand_path   = '🗑/' . pieces[-1]

            elseif  expand_path =~ '/s_kaggle'
                let pieces =  expand_path ->split('/s_kaggle/')
                let expand_path   = 'ҡ/' . pieces[-1]

            elseif  expand_path =~ '/coolS'
                let pieces =  expand_path ->split('/coolS/')
                let expand_path   = 'מּ/' . pieces[-1]
                                "\ cloud 云 表示可以迁移的仓库
            el

                "\ 不改变expand_path
            en

            "\ echom expand_path[-1:]
            let last_char = expand_path[-1:]
                    "\     Use [-1:] to get the last byte.
                        "\ because a negative index   always results in an empty string ( backward compatibility).

            if last_char != '\/'
            "\ "\ 以奇怪字符或结尾的, 加上`/`
            "\ if last_char =~ '\f'   ||
            "\ \ ( char2nr( last_char ) >= 19968 ) && ( char2nr( last_char ) <= 40869 )
            "\   "\ 加了这行还是无法处理中文

                let expand_path .= '/'
            en

        return expand_path . file_with_icon . ''
    endf

    "\ set stl+=\ %{expand('%:h')}\ \     " File+path
    "\ set stl+=%#Hi_status_3#
    "\ set stl+=%{strftime('%H:%M')}
        "\ zsh下敲date, 显示中国格式的时间, 但这里还是慢了8小时
        "\ 就算设了LC_ALL 是zh_CN.UTF-8, 还是不行
        "\ 可能原因: brew的tzselect等命令 代替了apt管的命令. brew的glibc和 debian还不能完美共处?
        "\ solution: /home/wf/dotF/zsh/.zshenv里  export TZ=Asia/Shanghai
        "\
    set stl+=%#Hi_status_2#



    " set stl+=\[buf号:%n]                  " buffer 号

	fun! Bad_news_coc() abort
        let bad_news = get(b:, 'coc_diagnostic_info', {})
            "   l表示local, 函数内的变量,可以省略
            " let l:bad_news = get(b:, 'coc_diagnostic_info', {})

        if empty(bad_news)
            return ''
        en

        let msgs = []
        if get(bad_news, 'error', 0)
            call add(msgs, '错误数:' . bad_news['error'])
        en

        if get(bad_news, 'warning', 0)
            call add(msgs, '警告数:' . bad_news['warning'])
        en

        return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
    endfunc

    set stl^=%1*%{Bad_news_coc()}
    " 就算换行是CR NL  ,好像也没啥要特别注意的

    "\ coc的, 不知道影响哪里
        "\ set statusline+=%4*%{coc#status()}%{get(b:,'coc_current_function','')}
        "\ fun! StatusDiagnostic() abort
        "\     let info = get(b:, 'coc_diagnostic_info', {})
        "\     if empty(info) | return '' | endif
        "\     let msgs = []
        "\     if get(info, 'error', 0)
        "\         call add(msgs, 'E' . info['error'])
        "\     en
        "\     if get(info, 'warning', 0)
        "\         call add(msgs, 'W' . info['warning'])
        "\     en
        "\     return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
        "\ endf
        "\ set stl+=%1*%{StatusDiagnostic()}

    " 好像没啥用:
        " set stl+=\ \[
        " set stl+=%2*%{get(g:,'coc_git_status','')}
        " set stl+=\]
        " set stl+=%2*%{get(b:,'coc_git_status','')}

        " 插到开头
        "\ set stl+=\ %{&spelllang}\             " Spell language?



    if $TMUX != ''  "\ windows terminal 和neovide的底色不同, 所以这里要配合
        "\ todo: 这会导致整个nvim很慢?
        "\ 为啥BufEnter有时没动静
        au AG BufEnter,BufLeave,TermOpen,WinEnter,WinNew   *
                            \if &buftype == 'terminal' ||  exists('b:term_title')
                            \|    if winnr() == winnr('$')
                            \|       setl stl=%1*
                            "\ \|       setl stl=%1*%{'\ ﬢ\ '->repeat(2)}
                            \|    else
                            \|       setl stl=%1*%{'ﬢ\ '->repeat(140)}
                            \|    endif
                            \| endif

        "\ au AG TermOpen            *  setl stl=%#Hi_status_2#
        "\ au AG TermOpen            *  setl stl=%1*%{'ﬢ\ '->repeat(140)}
        "\ au AG TermOpen            *  setl stl=%#Hi_status_2#%{'\ \ -\ =\ '->repeat(4)}%=%{'-\ =\ \ '->repeat(4)}
    el
        au AG TermOpen            *  setl            stl=%9*%{'\ \ -\ =\ '->repeat(4)}%=%{'-\ =\ \ '->repeat(4)}
    en
        "\  在 /home/wf/dotF/cfg/nvim/ReloaD.vim 里加了if exists('b:term_title'), TermEnter就多余了

            "\ au AG TermOpen,TermEnter  *  setl stl=%9*%{'-=-\ \ \ \ \ \ \ \ '->repeat(5)}
            "\ au AG TermOpen,TermEnter  *  setl  stl=%3*%{'-=-\ \ \ \ \ '->repeat(3)}

            " au AG BufWinEnter,WinEnter  term://* setl  stl=%9*%{'-\ '->repeat(30)}
                " au AG TermEnter  * setl  stl=%!repeat('-', 10)  " 逗号后的空格, 要escape, 不然断开
                "\ au AG TermEnter,TermOpen  *

                "\ au AG TermOpen  * echom  expand('<abuf>')

                "\ au AG TermOpen  *
                "\ au AG TermEnter  *
                " 不生效:
                " au AG BufWinEnter,WinEnter  term://* setl  laststatus=0 | setglobal laststatus=2
                "\ au AG   TermOpen    *
                          "\ \  call Wf_term_stl(expand('<abuf>'))
                          "\               "\ 位于最底下的terminal window, 不要显示分割线----
                          "\
                          "\   fun! Wf_term_stl(buf_nr)
                          "\       let out_str = '%#Normal#'
                          "\       if winnr('$') >= 2
                          "\           let a_num = bufwinnr( a:buf_nr )
                          "\           "\ echom "a_num 是: "   a_num
                          "\           "\ 如果配合BufWinEnter,WinEnter , a_num显示-1, 此时有了buffer, 但还没窗口?
                          "\           let line1_of_win = win_screenpos( a_num )[0]
                          "\           if line1_of_win < 10  " ( 被n调水平线劈开, 除了最底下的window )
                          "\           "\ tabline所在行号是1
                          "\               let out_str .= repeat('- ', 3)
                          "\           en
                          "\           exec 'setl stl="'  out_str . '%#Normal#' .  '"'
                          "\       el
                          "\           exec 'setl stl="'  '===' . '%#Normal#' .  '"'
                          "\
                          "\       en
                          "\
                          "\
                          "\   endf


    au AG BufEnter * if &fileformat != 'unix'
                        \| if &stl !~ 'dos格式'
                            \| setl stl^='dos格式_小心EOL'
                            "\ \| setl stl%='dos格式_小心EOL'
                        \| en
                    \| en



    "\ dap
        au AG BufNew,BufEnter  *  if bufname() == '[dap-repl]'      | setl stl=%#Hi_status_2#REPL  | endif
        au AG BufNew,BufEnter  *  if bufname() == 'DAP Stacks'      | setl stl=%#Hi_status_2#Stack | endif

        au AG BufNew  *  if bufname() == 'DAP Scopes'      | setl stl=%#Hi_status_2#scope | endif
        au AG BufNew  *  if bufname() == 'DAP Breakpoints' | setl stl=%#Hi_status_2#break | endif

        "\ au AG BufNew,BufEnter  *  if bufname() == ''                | setl stl=%#Hi_status_2#空      | endif
                                     "\ 这样用的是BufEnter前的bufname


    fun! Nearest_Method_Or_Function() abort
        if ['zsh', 'bash', 'sh', 'python', 'lua', 'vim', 'js', 'java', 'c', 'cpp'] ->index(&ft) != -1
            return '| 函数: ' ..  get(b:, 'vista_nearest_method_or_function', '')
        else
            return ''
        en
    endf

    set stl+=%{Nearest_Method_Or_Function()}
    "\ 需要再开:
    set stl+=\ %{FugitiveStatusline()}
    "\ set stl+=\|\ git信息:\ %{FugitiveStatusline()}

    set stl+=\ \ %r\     " %r  readonly, 显示 [RO]
    set stl+=\ \ %w\     " Top/bot.

    "\ set stl+=():\ %{Nearest_Method_Or_Function()}

    " By default vista.vim never run if you don't call it explicitly.
    "
    " If you want to show the nearest function in your statusline automatically,
    " you can add the following line to your vimrc
    au VimEnter * call vista#RunForNearestMethodOrFunction()


