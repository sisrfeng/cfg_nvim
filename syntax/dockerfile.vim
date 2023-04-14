" Maintainer:   Honza Pokorny <https://honza.ca>
" Last Change:  2020 Feb 11

" https://docs.docker.com/engine/reference/builder/

if exists("b:current_syntax")
    finish
en

syn  include @JSON syntax/json.vim
unlet b:current_syntax

syn  include @Shell syntax/sh.vim
unlet b:current_syntax

syn  case ignore
    syn  match dockerfileLinePrefix
        \ /\v^\s*(ONBUILD\s+)?\ze\S/
        \ contains=dockerfileKeyword
        \ nextgroup=dockerfileInstruction
        \ skipwhite

    syn  region dockerfileFrom
        \ matchgroup=dockerfileKeyword
        \ start=/\v^\s*(FROM)\ze(\s|$)/
        \ skip=/\v\\\_./
        \ end=/\v((^|\s)AS(\s|$)|$)/
        \ contains=dockerfileOption

    syn  keyword dockerfileKeyword contained
        \ ADD
        \ ARG
        \ CMD
        \ COPY
        \ ENTRYPOINT
        \ ENV
        \ EXPOSE
        \ HEALTHCHECK
        \ LABEL
        \ MAINTAINER
        \ ONBUILD
        \ RUN
        \ SHELL
        \ STOPSIGNAL
        \ USER
        \ VOLUME
        \ WORKDIR

    syn  match dockerfileOption contained /\v(^|\s)\zs--\S+/

    syn  match dockerfileInstruction
        \ contained
        \ /\v<(\S+)>(\s+--\S+)*/
        \ contains=dockerfileKeyword,dockerfileOption
        \ skipwhite
        \ nextgroup=dockerfileValue

    syn  match dockerfileInstruction
        \ contained
        \ /\v<(ADD|COPY)>(\s+--\S+)*/
        \ contains=dockerfileKeyword,dockerfileOption
        \ skipwhite
        \ nextgroup=dockerfileJSON
    syn  match dockerfileInstruction
    \ contained
    \ /\v<(HEALTHCHECK)>(\s+--\S+)*/
    \ contains=dockerfileKeyword,dockerfileOption
    \ skipwhite
    \ nextgroup=dockerfileInstruction
    syn  match dockerfileInstruction
    \ contained
    \ /\v<(CMD|ENTRYPOINT|RUN)>/
    \ contains=dockerfileKeyword
    \ skipwhite
    \ nextgroup=dockerfileShell
    syn  match dockerfileInstruction
    \ contained
    \ /\v<(CMD|ENTRYPOINT|RUN)>\ze\s+\[/
    \ contains=dockerfileKeyword
    \ skipwhite
    \ nextgroup=dockerfileJSON
    syn  match dockerfileInstruction
    \ contained
    \ /\v<(SHELL|VOLUME)>/
    \ contains=dockerfileKeyword
    \ skipwhite
    \ nextgroup=dockerfileJSON

    syn  region
    \ dockerfileString
    \ contained
    \ start=/\v"/
    \ skip=/\v\\./
    \ end=/\v"/
    syn  region dockerfileJSON
    \ contained
    \ keepend
    \ start=/\v\[/
    \ skip=/\v\\\_./
    \ end=/\v$/
    \ contains=@JSON
    syn  region dockerfileShell
    \ contained
    \ keepend
    \ start=/\v/
    \ skip=/\v\\\_./
    \ end=/\v$/
    \ contains=@Shell
    syn  region dockerfileValue
    \ contained
    \ keepend
    \ start=/\v/
    \ skip=/\v\\\_./
    \ end=/\v$/
    \ contains=dockerfileString

    syn  region dockerfileComment
    \ start=/\v^\s*#/
    \ end=/\v$/

    set commentstring=#\ %s

hi def link dockerfileString String
hi def link dockerfileKeyword Keyword
hi def link dockerfileComment Comment
hi def link dockerfileOption Special

let b:current_syntax = "dockerfile"
