" todo:
    " ref: https://github.com/bpstahlman/txtfmt



" 还是自己配吧, 这个主题的红色不好看:
        " vim-solarized8/colors/solarized8.vim
        " set background=light
        "
        " if !exists('g:vscode')
        "     autocmd vimenter * ++nested colorscheme solarized8 | hi XXX
        " endif
        "
        " create a light color theme for vim

" 原作者给的Options:, 仅留作参考:

" 作者信息:
    " https://github.com/jonathanfilip/lucius
    " https://github.com/jonathanfilip/vim-lucius

set termguicolors  " term use gui color ( 24-bit colours).

unlet! g:colors_name
set background=light
hi clear  " 依赖于background的取值
          " 用默认的highlight


if exists("syntax_on")
    syn    reset
        " It is a bit of a wrong name,
        "     since it does not reset any syntax items,
        "     it only make the highlighting back to the default.
en


" Color Definitions
    "\ 背景色  (只有开了neovide才需要. windows terminal有背景色, neovide目前好像没有, 这导致感觉 不对称)
        let g:bg_wf = 'faf4e4'
                 "\ rgb(250, 244, 228)
        "\ let g:bg_wf = 'f1ecdc'
        "\ let g:bg_wf = 'e8e9db'  "
        "\ let g:bg_wf = 'f0f0e0'


" 原作者的内容
    " 多个微调选项
        let s:contrast = "normal"
        " let s:contrast = "low"


    " Text Groups:

        let s:normal_items = [
            \  "ColorColumn",
            \  "Comment",
            \  "Conceal",
            \  "Constant",
            \  "Cursor",
            \  "CursorColumn",
            \  "CursorIM",
            \  "CursorLine",
            \  "DiffAdd",
            \  "DiffChange",
            \  "DiffDelete",
            \  "Directory",
            \  "Error",
            \  "ErrorMsg",
            \  "Identifier",
            \  "IncSearch",
            \  "LineNr",
            \  "MatchParen",
            \  "ModeMsg",
            \  "MoreMsg",
            \  "NonText",
            \  "Pmenu",
            \  "PmenuSbar",
            \  "PmenuSel",
            \  "PmenuThumb",
            \  "PreProc",
            \  "Question",
            \  "Search",
            \  "Special",
            \  "SpecialKey",
            \  "Statement",
            \  "StatusLine",
            \  "StatusLineNC",
            \  "TabLine",
            \  "TabLineFill",
            \  "Todo",
            \  "Type",
            \  "VertSplit",
            \  "Visual",
            \  "WarningMsg",
            \  "WildMenu",
            \  "SignColumn",
            \  ]

        let s:bold_items = [
            \  "DiffText",
            \  "Title",
            \  ]

            " let s:bold_items2 =
            " 用于gui?


        let s:underline_items = [
          \  "Underlined",
          \  "VisualNOS",
          \  ]

        " let s:undercurl_items = [ "SpellBad", "SpellCap", "SpellLocal", "SpellRare" ]
        let s:undercurl_items = []


    " Clear default settings
        for s:item in  s:normal_items
                   \ + s:bold_items
                   \ + s:underline_items
                   \ + s:undercurl_items
            exec "silent! hi clear"..s:item
                " 清掉列出的group的所有颜色设置
            " 如果不加这行, 会被其他插件搞乱?
            " exec "silent! hi "..s:item.."guifg=None guibg=none gui=None"
        endfor


        " 'Normal' Colors:

            if exists('g:wf_vidE')
                exe 'hi Normal    guifg=#444444 gui=none  guibg=#' . g:bg_wf
                       hi VertSplit guifg=#e4e4e4
            el
                       hi Normal    guifg=#444444 gui=none guibg=none
                       hi VertSplit guifg=#e4e4e4          guibg=#afd7ff
            en


        " Text Markup
        " vimHiKeyList
        " 如果不加gui=none, 有些被变成bold了, 不知道为啥
            hi Statement    guifg=#807030    gui=none
            hi Keyword      guifg=#805f00    gui=none
            hi Function     guifg=#209080    gui=none
            hi Constant     guifg=#af5f90    gui=none
            hi NonText      guifg=#afafd7    gui=none
            hi String       guifg=#508a9a    gui=none
            hi Directory    guifg=#00875f    gui=none
            hi PreProc      guifg=#008787    gui=none
            hi Title        guifg=#00605f    gui=none
            hi Identifier   guifg=#255030    gui=none
            "\ hi Identifier   guifg=#257730    gui=none
            hi Type         guifg=#106057    gui=none
            hi Delimiter    guifg=#000000    gui=none   guibg=none
                " 括号等
            hi Special      guifg=#8f3057    gui=none
            hi SpecialChar  guifg=#8f6057    gui=none
            hi SpecialKey   guibg=#fdf6ef    gui=none   guifg=#443377
              " unprintable的字符<CR>输入的等

            " hi  Conceal guifg=none guibg=none gui=none
            hi  clear Conceal


        " Highlighting
            hi      vimUserFunc  guifg=#454090 guibg=none gui=none
            hi      vimFuncVar   guifg=#4540a0 guibg=none gui=none



            " Messages:

                hi Question     guifg=#000000 guibg=none    gui=bold
                hi MoreMsg      guifg=#0087ff
                hi WarningMsg   guifg=#aa9900
                "\ 在checkhealth里:
                    "\ hi def link            healthError     Error


            " UI:
                hi clear Pmenu
                hi Pmenu        guifg=bg
                hi PmenuSel     guifg=fg
                hi PmenuThumb   guifg=fg
                hi WildMenu     guifg=fg
            " Cursor
            " let &colorcolumn=&tabstop
            set cursorline  " 突出显示当前行
            " hi CursorLine gui=bold guibg=#ede6e3
                        "\ todo:
                           "\ bold导致有些字体(比如 ==)被neovide 搞成ligature
                                       "\ 颜色不生效

            hi CursorLine   guifg=none gui=bold   guibg=#faf4e4
                                               "\ 全局bg:faf4e4, 叠加后 更加亮?
            "\ if exists('g:wf_vidE')
            "\     hi CursorLine   guifg=none gui=bold  guibg=#e8e9e0
            "\ el
            "\     hi CursorLine   guifg=none gui=bold   guibg=#f8f2e2
            "\ en

            "\ 突出显示当前col  " 导致慢
                " set cursorcolumn  "
                "\ hi CursorColumn  guifg=none gui=bold guibg=none

            hi Visual   guibg=#e0e9e0 guifg=none  gui=none
                " 在vv v和<M-p>等 动态设置hi Visual

            hi Cursor   gui=none  guifg=none guibg==none
                  "           character under the cursor
                            "\ neovide里有时变黑, ReloaD后恢复浅蓝

            " hi link Cursor DebuG
            hi link VisualNOS   DebuG
            hi link CursorIM    DebuG
            "
            hi ColorColumn                  guibg=#f2f6e3
            hi LineNr       guifg=#9e9e9e   guibg=#dadada


            hi Folded   guibg=none   guifg=#333344
            hi FoldColumn  guibg=#bdc6c3  guifg=#909090
            " hi SignColumn                 guibg=#d0d0d0
            hi SignColumn  guibg=#a0a5a3  guifg=#123456

            hi PmenuSel                     guibg=#afd7ff
            hi WildMenu                     guibg=#afd7ff
            if s:contrast == "low"
                hi Pmenu                        guibg=#9e9e9e
                hi PmenuSbar    guifg=#9e9e9e   guibg=#626262
                hi PmenuThumb                   guibg=#9e9e9e
                hi SignColumn   guifg=#808080
            el
                hi Pmenu                        guibg=#808080
                hi PmenuSbar    guifg=#808080   guibg=#444444
                hi PmenuThumb                   guibg=#9e9e9e
                hi SignColumn   guifg=#626262
            en


        " Diff:
            hi clear DiffAdd DiffChange DiffDelete DiffText
            hi DiffAdd     guibg=#e8efdb
            hi DiffChange  guibg=#eee8d5

            "\ hi link DiffDelete  Normal  \ 这会被其他地方清理并覆盖?
            hi DiffDelete  guifg=fg  gui=none guibg=#f8e8db

            hi DiffText      guifg=none  gui=none             guibg=#d7d7af
                "\ hi DiffText   gui=none guifg=#f26262 guibg=none
                " hi DiffText   guifg=#000033 guibg=#DDDDFF gui=none

            "     hi DiffText     guifg=#ff8700
            "     hi DiffText     guifg=#d75f00

       "\ diffchar
            hi dcNormal                                      guifg=fg       guibg=bg
            hi dcCursor        gui=reverse,nocombine         guifg=#444444
            hi dcDiffChange                                  guifg=fg       guibg=bg
            hi dcDiffText      gui=bold,nocombine            guifg=#444444  guibg=none
            hi dcDiffAdd       gui=nocombine                 guifg=#444444  guibg=none
            hi dcDiffDelEdge   gui=bold,underline,nocombine  guifg=#444444  guibg=none
            hi dcDiffDelete    gui=bold,nocombine            guifg=Blue     guibg=none




        " Spelling
            hi clear  SpellBad
            hi clear  SpellCap
            hi clear  SpellLocal
            hi clear  SpellRare

            "\ hi SpellBad     guisp=#d70000
            hi SpellCap     guisp=#00afd7
            hi SpellLocal   guisp=#d7af00
            hi SpellRare    guisp=#5faf00
            "\ hi link SpellBad     debug



        " Miscellaneous
            hi clear Ignore
            hi Ignore       guifg=none guibg=none gui=none
            hi Underlined   guifg=fg


        " Text Emphasis
            for s:item in s:undercurl_items
                exec   "hi "..s:item.." gui=undercurl"
            endfor

            for s:item in s:bold_items
                exec "hi "..s:item.." gui=bold"
            endfor


            for s:item in s:underline_items
                exec "hi "..s:item.." gui=underline"
            endfor

" my color
    hi   StatusLine     guibg=#f5f5e3   guifg=#005060   gui=none
    hi StatusLineNC   guibg=#f5f0e3   guifg=#005060   gui=none

    hi vimSynOption guifg=#aa80aa

    exe 'hi Half_tranS   guibg=none gui=none  guifg=#' . bg_wf
    hi Vim_funC    guifg=none    guibg=none gui=bold

    hi  EndOfBuffer   guifg=#e8ffdb  gui=none guibg=none
    "\ hi  EndOfBuffer   guifg=#e8e9db  gui=none guibg=none
        "\ 避免dap-ui的buffer里一堆¿~¿


    hi  CopilotSuggestion   guibg=none      guifg=#808f80
    hi  Menu                guibg=#abefcd   guifg=#123456
    hi  Pmenu               guibg=#ede6d3   guifg=none     gui=none
    hi PmenuSbar           guibg=#ede6d3   guifg=none     gui=none
    hi PmenuThumb          guibg=#888888   guifg=none     gui=none
    hi  Error               guibg=none      guifg=#d78700  gui=bold
        " 冒号会被高亮
        " Error无法直接通过regex定义, vim内部用c写的?

    hi DebuG      guifg=#000000   guibg=#ff0000 gui=underline,bold,italic

    hi Stand_ouT  guifg=#cc00ff guibg=#cddac3

    hi ModeMsg    guifg=#a4a4a4
    hi ErrorMsg   guifg=#121211 guibg=#cddac3

                            "\ 放init.vim最开头, 这样才能在更多情况下生效?
                            " 不, 会被插件覆盖. 还是放这里吧
                            " 无法影响 更这项之前出现的error(如果是启动init.vim前的错误, 我的配置管不着)



    " 关于search的highlight
        "\ set nohlsearch " 高亮search
        nno <Leader>h :set hlsearch!<CR>

        nno <Leader>H :Verbose hi <c-r><c-w><cr>
        "  todo: 自动取消高亮  (不够智能 先不用)
            " let s:current_timer = -1
            "
            " func! Highlight_Search_off(timerId)
            "     set hlsearch!
            " endf
            "
            " func! ResetTimer()
            "     if s:current_timer > -1
            "         call timer_stop(s:current_timer)
            "     endif
            "                                     " 第一个参数：按键多少ms后 自动取消
            "     let s:current_timer = timer_start(3000, 'Highlight_Search_off')
            " endf
            "
            "
            " nno <silent> N N:call ResetTimer()<CR>
            " nno <silent> n n:call ResetTimer()<CR>

    " 高亮todo和word under cursor等, 随时toggle
    " :
        let g:vim_current_word#highlight_delay        = 2000
        let g:vim_current_word#highlight_twins        = 1
        let g:vim_current_word#highlight_current_word = 1
"
            "         func! Toggle_cursor_worD() abort
            "             if  g:vim_current_word#highlight_twins == 1
            "                let g:vim_current_word#highlight_twins = 0
            "
            "             el
            "                let g:vim_current_word#highlight_twins = 1
            "             en
            "         endf
            "
        au AG Syntax *   syntax match   Always_hI  '!!!'
        hi link Always_hI  In_QuestionMark

        nnor <leader>ll :call Toggle_hl_hint()<cr>
            func! Toggle_hl_hint() abort
                if s:hl_hint == 1
                    set nohlsearch
                    hi clear  Note
                    hi clear  Todo
                    hi clear  Show_spacE
                    let s:hl_hint = 0
                el
                    set hlsearch
                    hi   NotE        guifg=none guibg=none  gui=underline
                    hi   Todo        guifg=none guibg=none  gui=underline
                    let s:hl_hint = 1
                en
            endf

            hi Show_spacE guifg=green guibg=#fdf6e3
                call matchadd('Show_spacE', '\s$')
                call matchadd('Show_spacE', '^\t')

            if exists('b:term_title')  | hi clear  Show_spacE  | en


            let s:hl_hint = 1  "\ 默认启用这些高亮

                hi clear  Todo
                au AG Syntax *  call matchadd('Todo',  '\v\c\W \zs(todo|fixme|buggy|hack)'  )

                hi NotE    guifg=none guibg=#efefc5  gui=bold
                    let id_useless =   'NotE' ->matchadd('However')
                    let id_useless =   'NotE' ->matchadd('meaning that')
                    let id_useless =   'NotE' ->matchadd('which means that')
                    let id_useless =   'NotE' ->matchadd('specifically')
                    let id_useless =   'NotE' ->matchadd('\Vi.e.')
                    let id_useless =   'NotE' ->matchadd('!!')
                         " 用作method, 用let或啥都不加 都不行.
                         " 加个let XXX =

                hi   NotE        guifg=none guibg=none  gui=underline
                hi   Todo        guifg=none guibg=none  gui=underline

                set incsearch
                hi IncSearch   guifg=000000 guibg=#c0e9e3 gui=bold,underline,standout
                    "\ 高亮当前文本?
                hi Search      guifg=000000 guibg=#f0e9c3 gui=none
                    "\ 高亮所有匹配文本?
                hi Substitute  guifg=000000 guibg=#f0e9e3 gui=underline
                " hi EasyMotionMoveHL guibg=green guifg=black
                " hi EasyMotionIncSearch guibg=green guifg=black

    " 关于comment的highlight

        hi Comment guifg=#808f80 guibg=none gui=none
        let g:_comment_hi = 'noraml'
            " Comment的syntax把我的In_BackticK等覆盖了吧, 就算下面这样 也无法在注释区域 显示其他高亮
                " hi Comment gui=none guifg=none guibg=none
                " hi clear Comment (清掉Comment的highlight, 而非用default) 也不行


        " au AG BufEnter,WinEnter *.txt hi! Comment guifg=#10500f guibg=none gui=none
        " au AG BufLeave,WinLeave *.txt hi! Comment guifg=none  |  let g:_comment_hi = 'noraml'
        "                          " 本想恢复常规的highlight, 但一旦设了highlight, 就会重复上色?
        "                          如何设置local的highlight ?

        hi Fade_out guifg=#808080

        func! Comment_01()
            if g:_comment_hi == 'hide'
            "\ 恢复正常的注释: (直接ReloaD更快? 而且可以减少autocmd数量)
                let g:_comment_hi = 'fade_out'
                hi! link Comment Fade_out
                hi! link In_fancY None
                hi Note    guifg=#000000 guibg=#ddf6d5
                hi Todo    guifg=#000000 guibg=#fdf6d5  gui=bold

            elseif  g:_comment_hi == 'fade_out'
                let g:_comment_hi = 'standout'
                hi Comment guifg=44f744 guibg=none
            el
                let g:_comment_hi = 'hide'
                exe 'hi Comment  guibg=none gui=none   guifg=#' . g:bg_wf
                hi! link In_fancY         Comment
                hi! link In_BackticK      Comment
                hi! link In_2BackticK     Comment
                hi! link In_AcutE         Comment
                hi! link In_QuestionMark  Comment

                hi clear Note
                hi clear Todo

            en
            echo g:_comment_hi
        endf

        nno      <leader>c :call Comment_01()<CR>


    "\ " terminal:
    "\ 不加这些,
        "会导致在neovide里 红 蓝 绿等显得很刺眼
        "(但在windows terminal下, (进不进tmux都一样), nvim里的terminal就挺好看, )
    "\ 加了这些,
    "    用neovide或windows terminal (进不进tmux都一样)
    "    nvim里的termnial里, green显示为黄色

    "\ 从vscode的/C:/Users/noway/AppData/Roaming/Code/User/settings.json复制来, 主要改了左边的key的名字
        let g:terminal_color_0  = "#161612"
        let g:terminal_color_8  = "#839496"

        let g:terminal_color_1  = "#DC322F"
        let g:terminal_color_9  = "#DC322F"

        let g:terminal_color_2  = "#428f5c"
        let g:terminal_color_10 = "#4da758"

        let g:terminal_color_3  = "#B58900"
        let g:terminal_color_11 = "#B58900"

        let g:terminal_color_4  = "#3876a1"
        let g:terminal_color_12 = "#268BD2"

        let g:terminal_color_5  = "#2e837c"
        let g:terminal_color_13 = "#2eafa4"

        let g:terminal_color_6  = "#5e62aa"
        let g:terminal_color_14 = "#8389f6"

        let g:terminal_color_7  = "#eee8d5"
        let g:terminal_color_15 = "#f7eeee"

    hi Conditional gui=none guibg=none guifg=#303030

" sandwich
    hi OperatorSandwichBuns     guifg='#aa91a0' gui=underline
    hi OperatorSandwichChange   guifg='#edc41f' gui=underline
    hi OperatorSandwichAdd      guibg='#b1fa87' gui=none
    hi OperatorSandwichDelete   guibg='#cf5963' gui=none


hi CurrentWordTwins  guibg=#e0e0d4
    " 太浅色不太好, 遇到typo不能及时发现
" hi CurrentWord       gui=underline guibg=#dff6e3  " 中英文在一起时 被误以为是一个word
"

" tree-sitter的
" 默认值:
    "\ hi  TSModuleInfoGood guifg=LightGreen gui=bold
    "\ hi  TSModuleInfoBad  guifg=Crimson
    "\ hi   link   TSModuleInfoHeader      Type
    "\ hi   link   TSModuleInfoParser      Identifier
    "\ hi   link   TSModuleInfoNamespace   Statement
    "\ hi   link   TSKeyword               Statement
    "\ hi   link   vimTSVariableBuiltin    vimOption


    " 卸掉这个插件了
    " " tree-sitter的rainbow
    "     " 会干扰tex的括号
    "     hi rainbowcol7 guifg=#336600
    "     hi rainbowcol6 guifg=#558800
    "     hi rainbowcol5 guifg=#779900
    "     hi rainbowcol4 guifg=#99aa00
    "     hi rainbowcol3 guifg=#aabb00
    "     hi rainbowcol2 guifg=#bbcc00
    "     hi rainbowcol1 guifg=#ccdd00

hi Sk_color  guifg=#000000  guibg=#e0e9c9  gui=none
"\                                            gui=underline
let g:skim_colors = {
    \ 'fg'               : ['fg',     'Normal'],
    \ 'bg'               : ['bg',     'Normal'],
    \
    \ 'matched'          : ['fg',    'Sk_color'],
    \ 'matched_bg'       : ['bg',    'In_BackticK'],
    \ 'gutter'           : ['bg',    'DebuG'],
    "\ gutter:  Background of the gutter排水沟 on the left
    "\ \ 行号为啥和matched_bg一个颜色?
    "\ 当前行:
    \ 'current'          : ['fg',    'Sk_color'],
    \ 'current_bg'       : ['bg',    'Sk_color'],
    \
    \ 'current_match'    : ['fg',    'Sk_color'],
    \ 'current_match_bg' : ['bg',    'In_QuestionMark'],
    \
    \
    \ 'info'             : ['fg',    'Normal'],
    \ 'border'           : ['bg',    'Normal'],
    \ 'prompt'           : ['fg',    'Normal'],
    \ 'pointer'          : ['fg',    'Normal'],
    \ 'marker'           : ['fg',    'Normal'],
    \ 'spinner'          : ['fg',    'Normal'],
    \ 'header'           : ['fg',    'Normal'],
    \
    \ 'info_bg'            : ['bg',    'Normal'],
    \ 'prompt_bg'          : ['bg',    'Normal'],
    \ 'pointer_bg'         : ['bg',    'Normal'],
    \ 'marker_bg'          : ['bg',    'Normal'],
    \ 'spinner_bg'         : ['bg',    'Normal'],
    \ 'header_bg'          : ['bg',    'Normal'],
\ }


    " 在skim里淘汰了它们?
        " hi default fzf1   guifg=#E12672 guibg=#565656
        " hi default fzf2   guifg=#BCDDBD guibg=#565656
        " hi default fzf3   guifg=#D9D9D9 guibg=#565656

" coc
    "\ 现在禁用inlayHint 了
        hi link   CocInlayHint            DebuG
        hi link   CocInlayHintType        DebuG
        hi link   CocInlayHintParameter   DebuG


    hi  HighlightedyankRegion guifg=none guifg=none  gui=underline
    " help里不生效
        " 被coc覆盖了:
        " au AG TextYankPost * silent! lua vim.highlight.on_yank {higroup="CursorLine", timeout=150, on_visual=false}
        " au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false}

    hi  link CocErrorHighlight      DebuG
    hi  link   CocErrorSign      ErrorMsg
    hi  link   CocErrorFloat     Pmenu

    hi link CocSearch         String  "\ menu里的匹配到的字符
    hi CocMenuSel guibg=#e0e9c9 guifg=none gui=none
        "\ current menu item in menu dialog (should only provide  background color).
    hi link CocPumVirtualText   Fade_out "\ 不知道影响哪里
    hi link CocPumShortcut      Comment  "\ 类似[LS] [tag]的source
    hi link   CocPumMenu   DebuG
    hi link CocPumDeprecated DebuG
    hi link CocDisabled DebuG


    hi  link   CocWarningSign    WarningMsg
    hi  link   CocWarningFloat   Pmenu

    hi  link   CocInfoSign       MoreMsg
    hi  link   CocInfoFloat      Pmenu

    hi  link   CocHintFloat      Directory
    hi  link   CocHintFloat      Pmenu


    hi link  CocSelectedText     In_StaR
            "\ sign text of selected lines.
    hi link  CocSelectedLine     In_QuestionMark
    " hi link  CocYankLine         Comment
        "\ CocListMode         for mode in statusline of CocList.
        "\ CocListPath        for current cwd in statusline of CocList.




    " The modifier highlight groups have higher priority:
        " links to related |nvim-treesitter| highlight groups when possible and
        " fallback to builtin highlight groups,

        " use variable |g:coc_default_semantic_highlight_groups| to disable creation of these highlight groups.
        "
        " Currently only semantic tokens types and `deprecated` modifier have default highlight groups.
    "
        " ~/PL/nvim-treesitter/plugin/nvim-treesitter.vim
        " Add highlights for defaultLibrary modifier
            hi   link CocSemDefaultLibrary            TSOtherDefaultLibrary
            " TSTypeDefaultLibrary
            hi   link CocSemDefaultLibraryClass       TSTypeDefaultLibrary
            hi   link CocSemDefaultLibraryInterface   TSTypeDefaultLibrary
            hi   link CocSemDefaultLibraryEnum        TSTypeDefaultLibrary
            hi   link CocSemDefaultLibraryType        TSTypeDefaultLibrary
            hi   link CocSemDefaultLibraryNamespace   TSTypeDefaultLibrary

        " Add highlights for ¿declaration¿ modifier
            hi   link CocSemDeclaration               TSOtherDeclaration
            hi   link CocSemDeclarationClass          TSTypeDeclaration
            hi   link CocSemDeclarationInterface      TSTypeDeclaration
            hi   link CocSemDeclarationEnum           TSTypeDeclaration
            hi   link CocSemDeclarationType           TSTypeDeclaration
            hi   link CocSemDeclarationNamespace      TSTypeDeclaration

"\ markdown
    hi markdownError gui=none
        " 不加这行 :checkhealth时有个报错(但不碍事):
    hi htmlH2   guifg=#106057 gui=bold
    "\ hi markdownCode_BacktickS guibg=#f6f8fa  \ 放在了  /home/wf/PL/markdown/syntax/markdown.vim
" w3m-vim
    hi! link w3mSubmit    Special
    hi! link w3mInput     String
    hi! link w3mBold      Comment
    hi! link w3mUnderline Underlined
    hi! link w3mHitAHint  Question
    hi! link w3mAnchor    Label
    hi w3mLinkHover gui=bold
    exe 'hi w3mLink  gui=underline   guifg=#' . bg_wf

" matchup
    hi MatchParen gui=underline guibg=none guifg=#303030

" easymotion
    hi EasyMotionTarget guibg=none guifg=green
    hi EasyMotionShade  guibg=none guifg=#a0a0a0

    hi EasyMotionTarget2First guibg=none guifg=green
    hi EasyMotionTarget2Second guibg=none guifg=#a0e0ea

"\ rst:
    let g:rst_use_emphasis_colors = 0
    hi link rstExDirective Normal
    hi link rstDirective      Fade_out


hi link manOptionDesc  Normal

hi  A_strikE   guifg=#fbbbbb

let g:colors_name="leo_light"


