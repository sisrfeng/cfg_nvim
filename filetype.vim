"\ todo: nvim0.9将不再使用filetype.vim, 用filetype.lua代替
"\ 但本文件还有效
"\ 是因为放在自己的目录下, 就不会被覆盖?

if exists("did_load_filetypes")  | finish  | endif
          " did_load_filetypes是global的变量??

"\ 现在没加 let did_load_filetypes = 1,
    "\ 本脚本不会覆盖$RUNTIME/filetype.vim,
    "\ 但加了下面的autocmd, 遇到man文件, 设语法为man,
    "\ 由于有
          "\ if exists('b:current_syntax')
          "\     finish
          "\ endif
    "\ 不会再设syntax为nroff

aug  filetypedetect
    au! BufReadPost,BufNewFile     *.pyh      setfiletype pyh
    au! BufReadPost,BufNewFile     *.log      setfiletype log_wf

    au! BufReadPost,BufNewFile     *.{zz,z}      setfiletype zsh
    "\ au! BufNewFile,BufReadPost     *.man         setf man
          "\ Verbose au查时, 仍有:
              "\ filetypedetect  BufNewFile *.man setf nroff
              "\ (这么设, 主要是为了方便 写用生成man的nroff源码的人?)

          "\ 但syntax/xxx.vim里, 都有这:
                  "\ if exists('b:current_syntax')
                  "\     finish
                  "\ endif

              "\ 所以syntax/nroff不会影响man文件?

          "\ todo:
              " 我保存的man文件, 全用xxx.manu, 然后:
              au! BufNewFile,BufReadPost     *.mm   setf mm
                                                         "\ my man
              "\ 就不用顾虑.man的filetype被设为nroff?
    au! BufNewFile,BufReadPost     $HOME/PL/*/doc/*.txt           setf help
    au! BufNewFile,BufReadPost     $HOME/PL/help_me/vim9/*.txt    setf help
    "\ 有效, 参考了:
    "\ au BufNewFile,BufReadPost $VIMRUNTIME/doc/*.txt    setf help
    " 加叹号是为了这吗:
          " no other autocommands will set  'filetype' after this.
          "\ ($RUNTIME/filetype.vim里 au后不加叹号)
aug  END


    "\ *remove-filetype*
    "\     If a file type is detected that is wrong for you,
    "\     install a filetype.vim or  scripts.vim to ¿catch it¿ (see above).
    "\     You can set 'filetype' to a non-existing  name to avoid  that
    "\         it will be set later anyway:
    "\             ´:set filetype=ignored´
    "\
    "\     If you are setting up a system with many users,
    "\         and you don't want each user to add/remove the same filetypes,
    "\             consider writing the filetype.vim and  scripts.vim files
    "\             in a runtime directory that is used for everybody.
    "\             Check  the 'runtimepath' for a directory to use.
    "\
    "\             If there isn't one,
    "\                 set  'runtimepath' in the |system-vimrc|.
    "\             Be careful to keep the default  directories!
