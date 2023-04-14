" Language: Diff (context or unified) (跟set diff无关, 被diff的文件 如果是.vim, set ft?仍显示vim)
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last Change:  2021 Nov 14

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let b:undo_ftplugin = "setl modeline< commentstring<"

" Don't use modelines in a diff, they apply to the diffed file
setlocal nomodeline

" If there are comments
" they start with ¿#¿
let &l:commentstring = "# %s"
        "\ local to function??
        "\ 但commentstring是local to buffer的option啊

"\ only for MS-Windows
    if (has("gui_win32") ||  has("gui_gtk") ) &&
    \ !exists("b:browsefilter")
        let b:browsefilter = "Diff Files (*.diff)\t*.diff\nPatch Files (*.patch)\t*.h\nAll Files (*.*)\t*.*\n"
        let b:undo_ftplugin ..= " | unlet! b:browsefilter"
    endif


