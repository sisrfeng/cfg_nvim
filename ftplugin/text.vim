" Vim filetype plugin
" Language:		Text
" Maintainer:		David Barnett <daviebdawg+vim@gmail.com>
" Last Change:		2019 Jan 10

if exists('b:did_ftplugin')
  finish
en
let b:did_ftplugin = 1

let b:undo_ftplugin = 'setl  comments< commentstring<'

" We intentionally don't set formatoptions-=t since text should wrap as text.

" Pseudo comment leaders to indent bulleted lists with '-' and '*'.  And allow
" for Mail quoted text with '>'.
setl  comments=fb:-,fb:*,n:>
setl  commentstring=

nno si <Cmd>call Short_text()<cr>
fun! Short_text()
    % sub @^\s*\zs+--\++.*+$@@gce
    % sub @ |$@@gce
endf


" DIY开始:
"\ if 在Man下
if 0
"\ massren用txt文件 加这些会捣乱
    let a_modeline =  '--formatted by wf--'
    if getline(line('$')) != a_modeline &&
    \ line('$') > 30  "\ 避免搞乱我自己输出的文件
        exec '% subs#\v\S\zs  \ze\S# #ge'
                        " 行内的2个空格变1个
        "\ 缩进变为4的倍数
            silent! % sub #\v^ {1,3}\ze\S#    #ge
            silent! % sub #\v^ {5,7}\ze\S#        #ge
            silent! % sub #\v^ {9,11}\ze\S#            #ge

        "\ todo nroff可控制如何用hypen断句
        "\ https://stackoverflow.com/questions/23546272/in-linux-hyphen-is-a-multi-character-character
            % sub #\v\w\zs‐ {1,3}\ze\w##gce
            % sub #‐\n *\ze\w##gce
                       "\ 这里短横线这个字符, 是hypen (unicode 8208), 而非下面的¿-¿ (键盘上直接敲)
            "\ % sub #\v\w\zs- {1,3}\ze\w##gce

        silent! % sub #\v^\s*\zs(it is important to )?note that ##ge
        call funcS#Short_iT()

        % sub @\v\*\ze\w+\*@`@ge
        % sub @\v`\w+\zs\*@`@ge


        call setline(line('$')+1, ' ')
        call setline(line('$')+1, ' ')
        call setline(line('$')+1, a_modeline)
        2  "\ 跳到第2行
    en
en
