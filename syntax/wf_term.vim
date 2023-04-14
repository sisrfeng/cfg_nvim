syn keyword wf_termInter   KeyboardInterrupt conceal cchar=杀

syn match   wf_termLong_path     @/media/wf/data/large_wf/dir0/coolS@                     conceal cchar=שׂ

syn match   wf_termHideS         @remote: Powered by GITEE.COM \[GNK-6.4]@                conceal cchar=שׂ

syn match   wf_termHideS_by_color         @[0-9a-fA-F]\{20,}@           "\ 对tig显示的有效
hi wf_termHideS_by_color guifg=#d7d7d7

syn match   wf_termHideS         @([0-9a-fA-F]\{40})@                                     conceal cchar=ﬆ
          "\ 40位哈希值

syn match   wf_termHideS         @remote: Enumerating objects: \d\+, done\.@              conceal cchar=·
syn match   wf_termHideS         @remote: Counting objects: 100% (\d\+\/\d\+), done\.@    conceal cchar=·
syn match   wf_termHideS         @remote: Compressing objects: 100% (\d\+\/\d\+), done\.@ conceal cchar=·
syn match   wf_termHideS         @Requirement already satisfied.*$@                      conceal cchar=·
syn match   wf_termHideS         @Installing collected packages: .*$@                      conceal cchar=·
syn match   wf_termHideS         @  Attempting uninstall: .*$@                      conceal cchar=·
syn match   wf_termHideS         @    Found existing installation: .*$@                      conceal cchar=·
syn match   wf_termHideS         @      Successfully uninstalled .*$@                      conceal cchar=·
syn match   wf_termHideS         @command not found:.\{-}多余字符串_让之前敲的命令失效_避免误操作@                      conceal cchar=·
syn match   wf_termHideS         @.\{-}多余字符串_让之前敲的命令失效_避免误操作 ; @                      conceal cchar=新
syn match   wf_termHideS         @\d\d号\d\d点\d\d分\d\d秒@                      conceal cchar=·
syn match   wf_termHideS         @Running command git clone -q https.*$@                      conceal cchar=·

"\ paddle的傻逼输出
syn match   wf_termHideS         @.*gpu_resources.cc:61.*@                      conceal cchar=·
syn match   wf_termHideS         @.*gpu_resources.cc:91.*@                      conceal cchar=·

    "\ Uninstalling mmdet-2.28.1:


syn match   wf_termLong_path     @\v(\~|/home/wf)/d/coolS@                                conceal cchar=מּ
syn match   wf_termLong_path     @/.*/coolS@                                              conceal cchar=מּ

"\ syn match   wf_termLong_path  @\v(/.*|\~)/(\.trash|.t)@                                conceal cchar=🗑
"\ 会误杀

syn match   wf_termLong_path     @/home/linuxbrew/.linuxbrew@                             conceal cchar=צּ



