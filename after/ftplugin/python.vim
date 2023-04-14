fun! s:clean_py()
    silent! %sub @\V# %% [code]\.\*\$@# ----------------------------@ge
    silent! %sub @\V# %% [markdown]\.\*\$@# ----------------------------@ge
    set conceallevel=0

    "\ 函数里改了没用?
    "\ hi IncSearch guifg=white guibg=#ff0000 gui=underline
    % sub  @\v--\w+\zs-\ze\w+@_@gec
        "\ args里的¿-¿变¿_¿, 方便搜索
        "\ \i 能匹配非multi byte character
        "\ ¿\w¿ 不能
    set conceallevel=2
    hi IncSearch   guifg=000000 guibg=#c0e9e3 gui=bold,underline,standout
    call histdel('search', -3,)
endf

nno <buffer>  si  <cmd>hi IncSearch guifg=white guibg=#ff0000 gui=underline<cr><cmd>call <SID>clean_py()<cr>
