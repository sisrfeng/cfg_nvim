" Vim indent file
" Language:    Windows PowerShell
" URL:         https://github.com/PProvost/vim-ps1
" Last Change: 2017 Oct 19

if exists("b:did_indent")  | finish  | endif  | let b:did_indent = 1

"\ 不合我意:
    "\ setlocal smartindent  " smartindent is good enough for powershell
    "\     "\ When using the ">>" command,
    "\     "\     lines starting with '#' are not shifted right.
    "\
    "\     inoremap <buffer> # X#
    "\     "\ When typing '#' as the 1st character in a new line,
    "\     "\     the indent for that line is removed,
    "\     "\     the '#' is put in the 1st column.
    "\     "\     The indent is restored for the next line.
    "\     "\ If you don't want this,
    "\     "\     use this mapping:
    "\     "\         ":inoremap # X^H#",
    "\     "\             where ^H is entered with ctrl-v ctrl-h.


let b:undo_indent = "setl si<"
