" Vim syntax file
" Maintainer:   vacancy
" Previous Maintainer:  Eli Parra <eli@elzr.com>
" Last Change:  2019 Sep 17
" Version:      0.12

if !exists("main_syntax")
    " quit when a syntax file was already loaded
    if exists("b:current_syntax")
        finish
    en
    let main_syntax = 'json'
en

syn  match   jsonNoise           /\%(:\|,\)/

" NOTE that for the concealing to work your conceallevel should be set to 2

" Syntax: JSON Keywords
    " Separated into a match and region because a region by itself is always greedy
    syn match  jsonKeywordMatch /"\([^"]\|\\\"\)\+"[[:blank:]\r\n]*\:/ contains=jsonKeyword
    if has('conceal') && (!exists("g:vim_json_conceal") || g:vim_json_conceal==1)
         syn region  jsonKeyword matchgroup=jsonQuote start=/"/  end=/"\ze[[:blank:]\r\n]*\:/ concealends contained
    el
         syn region  jsonKeyword matchgroup=jsonQuote start=/"/  end=/"\ze[[:blank:]\r\n]*\:/ contained
    en

" Syntax: Strings
    " Separated into a match and region because a region by itself is always greedy
    " Needs to come after keywords or else a json encoded string will break the
    " syntax
    syn match  jsonStringMatch /"\([^"]\|\\\"\)\+"\ze[[:blank:]\r\n]*[,}\]]/ contains=jsonString
    if has('conceal') && (!exists("g:vim_json_conceal") || g:vim_json_conceal==1)
            syn region  jsonString oneline matchgroup=jsonQuote start=/"/  skip=/\\\\\|\\"/  end=/"/ concealends contains=jsonEscape contained
    el
            syn region  jsonString oneline matchgroup=jsonQuote start=/"/  skip=/\\\\\|\\"/  end=/"/ contains=jsonEscape contained
    en

" Syntax: JSON does not allow strings with single quotes, unlike JavaScript.
    syn region  jsonStringSQError oneline  start=+'+  skip=+\\\\\|\\"+  end=+'+


" Syntax: Escape sequences
    syn match   jsonEscape    "\\["\\/bfnrt]" contained
    syn match   jsonEscape    "\\u\x\{4}" contained

" Syntax: Numbers
    syn match   jsonNumber    "-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>\ze[[:blank:]\r\n]*[,}\]]"

" ERROR WARNINGS
if (!exists("g:vim_json_warnings") || g:vim_json_warnings==1)
    " Syntax: Strings should always be enclosed with quotes.
    syn match   jsonNoQuotesError  "\<[[:alpha:]][[:alnum:]]*\>"
    syn match   jsonTripleQuotesError  /"""/

    " Syntax: An integer part of 0 followed by other digits is not allowed.
    syn match   jsonNumError  "-\=\<0\d\.\d*\>"

    " Syntax: Decimals smaller than one should begin with 0 (so .1 should be 0.1).
    syn match   jsonNumError  "\:\@<=[[:blank:]\r\n]*\zs\.\d\+"

    " Syntax: No comments in JSON, see http://stackoverflow.com/questions/244777/can-i-comment-a-json-file
    syn match   jsonCommentError  "//.*"
    syn match   jsonCommentError  "\(/\*\)\|\(\*/\)"

    " Syntax: No semicolons in JSON
    syn match   jsonSemicolonError  ";"

    " Syntax: No trailing comma after the last element of arrays or objects
    syn match   jsonTrailingCommaError  ",\_s*[}\]]"

    " Syntax: Watch out for missing commas between elements
    syn match   jsonMissingCommaError /\("\|\]\|\d\)\zs\_s\+\ze"/
    syn match   jsonMissingCommaError /\(\]\|\}\)\_s\+\ze"/    "\ arrays/objects as values

    syn match   jsonMissingCommaError "\v}\_s+\ze\{"   " objects as elements in an array
    "\ syn match   jsonMissingCommaError /}\_s\+\ze{/   这会导致后续的一大段 被识别为Var等:
    syn match   jsonMissingCommaError /\(true\|false\)\_s\+\ze"/ "true/false as value
en


"\ Allowances for JSONP: function call at the beginning of the file, parenthesis and semicolon at the end.
"\ Function name validation based on  http://stackoverflow.com/questions/2008279/validate-a-javascript-function-name/2008444#2008444

syn match  jsonPadding "\%^[[:blank:]\r\n]*[_$[:alpha:]][_$[:alnum:]]*[[:blank:]\r\n]*("
syn match  jsonPadding ");[[:blank:]\r\n]*\%$"

"\ Syntax: Boolean
syn match  jsonBoolean /\(true\|false\)\(\_s\+\ze"\)\@!/

" Syntax: Null
syn keyword  jsonNull      null

" Syntax: Braces
syn region  jsonFold matchgroup=jsonBraces start="{" end=/}\(\_s\+\ze\("\|{\)\)\@!/ transparent fold
syn region  jsonFold matchgroup=jsonBraces start="\[" end=/]\(\_s\+\ze"\)\@!/ transparent fold

" Define the default highlighting.
    hi def link jsonPadding      Operator
    hi def link jsonString       String
    hi def link jsonTest         Label
    hi def link jsonEscape       Special
    hi def link jsonNumber       Number
    hi def link jsonBraces       Delimiter
    hi def link jsonNull         Function
    hi def link jsonBoolean      Boolean
    hi def link jsonKeyword      Label

if ( !exists("g:vim_json_warnings") || g:vim_json_warnings == 1 )
    hi def link jsonNumError             Error
    hi def link jsonCommentError         Error
    hi def link jsonSemicolonError       Error
    hi def link jsonTrailingCommaError   Error
    hi def link jsonMissingCommaError    Error
    hi def link jsonStringSQError        Error
    hi def link jsonNoQuotesError        Error
    hi def link jsonTripleQuotesError    Error
en

    hi def link jsonQuote           Quote
    hi def link jsonNoise           Noise

let b:current_syntax = "json"
if main_syntax == 'json'
    unlet main_syntax
en


"See https://twitter.com/elzr/status/294964017926119424
