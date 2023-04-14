" au AG BufEnter  *.mm  setl     ft=mm 没生效

if exists('b:did_ftplugin') || &filetype !=# 'mm'
"\ 这用这样基本就够了?:
"\ if exists('b:did_ftplugin')
    finish
en
let b:did_ftplugin = 1

" lua require("man").highlight_man_page()

" 刚进入.mm文件时,&ft是nroff,
" 再次进入其buffer时, &ft变为mm:
    " echom 'ftplugin/mm.vim里显示: &ft &syntax是:'
    " echom &ft &syntax
    " echom 'ftplugin/mm.vim里显示: &ft &syntax是:----------'

nno <silent> <buffer> go  :call mm#TOC_leo()<cr>:call docS#Toc_beautify()<CR>

nno <silent> <buffer>          <2-LeftMouse> :Man<CR>
nno <silent> <buffer> <nowait> q             :lclose<CR><C-W>c



" setl     iskeyword=@-@,:,a-z,A-Z,48-57,_,.,-,(,)
    " Parentheses and '-' for references like `git-ls-files(1)`;
    " '@' for systemd  pages;
    " ':' for Perl and C++ pages.
    " Here, I intentionally omit the locale  specific characters matched by `@`.

" setl     tagfunc=mm#goto_tag

" slow down vim:
    " setl     foldenable
    " setl     foldmethod=indent
    " setl     foldnestmax=4  " 默认的是1, 防止太慢?
    " setl     ts=4

let b:undo_ftplugin = ''

"\ BufModifiedSet使得<c-s> (  <Cmd>update<CR><Cmd>Runtime<CR>zv ) 无效
"\ au AG BufModifiedSet *.mm silent! write!
                          " 这个避免每次要敲Yes
                                    " 我diy后, 打开.mm文件就会修改,
                                    " 所以换buffer前要保存文件
                                    " 因为在其他地方设了set confirm (不设confirm,就会保存失败 导致换buffer失败?)
                                    " 每次打开都提示wirte or not
                                    "

    " 这几个会触发很多次
    " au AG FileType                mm silent! write! | echom 'asdfasdf'
    " au AG BufReadPost,BufNewFile     *.mm  silent! write!


"\ 一开始没加这个, 现在加的话 会搞乱?
"\ 不会
" DIY开始:
    let a_modeline =  '我的Man'
    if getline(line('$')) !~ a_modeline
        call mm#Short_maN()
        call setline(line('$')+1, a_modeline . strftime('  %y年%m月%d日') )
        "\ 搞这么多行, 是因为 要等新生成的文件 完整写入buffer吧
        2  "\ 跳到第2行
        2  "\ 跳到第2行
        2  "\ 跳到第2行
        2  "\ 跳到第2行
        2  "\ 跳到第2行
    en

    "\ 现在基本不需要了, 自动
        "\ nno <buffer>                   si             ms<esc><cmd>call mm#Short_maN()<cr><esc>`s

"\ nno  <buffer> <cr>   yiw  \ 算了, 别让跳转那么容易, 不然容易钻牛角尖

