" Language:             YAML (YAML Ain't Markup Language)
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se> (inactive)
" Last Change:          2020 Mar 02

if exists("b:did_ftplugin")
    finish
en
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = "setl com< cms< et< fo<"

setl  comments=:# commentstring=#\ %s expandtab
setl  formatoptions-=t formatoptions+=croql

if !exists("g:yaml_recommended_style") || g:yaml_recommended_style != 0
    let b:undo_ftplugin ..= " sw< sts<"
    setl  shiftwidth=2 softtabstop=2
en

let &cpo = s:cpo_save
unlet s:cpo_save
