"\ by lwf
"\ hide things like
"\ [yyyy-mm-dd]

if exists("b:current_syntax")  | finish  | endif



syn match logHide @\v^\[.{-}] @       conceal
syn match logHide @ INFO: @       conceal
syn match logHide @ ERROR: @       conceal
syn match logHide @ DEBUG: @       conceal


nno <buffer> si <Cmd>call Short_log()<cr>
                        fun! Short_log()
                             %sub @\v^\[.{-}]@@ge
                             %sub @ INFO:@@ge
                             %sub @ ERROR:@@ge
                             %sub @ DEBUG:@@ge
                        endf

let b:current_syntax = 'log_wf'
