" Language:         YAML (YAML Ain't Markup Language) 1.2  ( 但pyyaml基于yaml1.1 不能完全支持yaml1.2 )
" Maintainer:       Nikolai Pavlov <zyx.vim@gmail.com>
" Latest Revision:  2015-03-28
" 		    removed duplicate yamlKeyValueDelimiter (pull #4799)

"\ - You can enclose strings in single or double-quotes or no quotes at all.
"\ - YAML recognizes unquoted numerals as integers or floating point.
"\ The key is always a string. The value is a scalar so that it can be any datatype.

"\ https://www.cloudbees.com/blog/yaml-tutorial-everything-you-need-get-started
"\ 看本文件的笔记, 搜 tutorial:
"\ 被我改错了

    "\ if exists('b:current_syntax')
    "\     finish
    "\ en
    "\
    "\ let s:cpo_save = &cpo
    "\ set cpo&vim
    "\
    "\ " Choose the schema to use
    "\ " TODO: Validate schema
    "\ if !exists('b:yaml_schema')
    "\     if exists('g:yaml_schema')
    "\         let b:yaml_schema = g:yaml_schema
    "\     el
    "\         let b:yaml_schema = 'core'
    "\     en
    "\ en
    "\
    "\ "\ 定义一堆特殊字符
    "\     "\ ns: None Space?
    "\     let s:ns_char          = '\%([\n\r\uFEFF \t]\@!\p\)'
    "\                             "\ \uFEFF: Zero Width No-Break Space
    "\     let s:ns_word_char     = '[[:alnum:]_\-]'
    "\     let s:ns_uri_char      = '\%(%\x\x\|'.s:ns_word_char.'\|[#/;?:@&=+$,.!~*''()[\]]\)'
    "\     let s:ns_tag_char      = '\%(%\x\x\|'.s:ns_word_char.'\|[#/;?:@&=+$.~*''()]\)'
    "\
    "\     let s:c_ns_anchor_char = '\%([\n\r\uFEFF \t,[\]{}]\@!\p\)'
    "\     let s:c_indicator      = '[\-?:,[\]{}#&*!|>''"%@`]'
    "\     "\ 这里的¿>¿ 表示这个意思?:
    "\     "\ With the ¿>¿, you can specify a string in a block, 例子:
    "\         "\ bar: >
    "\             "\ this is not a normal string it
    "\             "\ spans more than
    "\             "\ one line
    "\             "\ see?
    "\
    "\     let s:c_flow_indicator = '[,[\]{}]'
    "\
    "\     let s:ns_char_without_c_indicator = substitute(s:ns_char, '\v\C[\zs', '\=s:c_indicator[1:-2]', '')
    "\
    "\     let s:_collection     = '[^\@!\(\%(\\\.\|\[^\\\]]\)\+\)]'
    "\     let s:_neg_collection = '[^\(\%(\\\.\|\[^\\\]]\)\+\)]'
    "\     fun s:SimplifyToAssumeAllPrintable(p)
    "\         return substitute(a:p, '\V\C\\%('.s:_collection.'\\@!\\p\\)', '[^\1]', '')
    "\     endf
    "\     let s:ns_char                     = s:SimplifyToAssumeAllPrintable(s:ns_char)
    "\     let s:ns_char_without_c_indicator = s:SimplifyToAssumeAllPrintable(s:ns_char_without_c_indicator)
    "\     let s:c_ns_anchor_char            = s:SimplifyToAssumeAllPrintable(s:c_ns_anchor_char)
    "\
    "\     function s:SimplifyAdjacentCollections(p)
    "\         return substitute(a:p, '\V\C'.s:_collection.'\\|'.s:_collection, '[\1\2]', 'g')
    "\     endf
    "\     let s:ns_uri_char = s:SimplifyAdjacentCollections(s:ns_uri_char)
    "\     let s:ns_tag_char = s:SimplifyAdjacentCollections(s:ns_tag_char)
    "\
    "\     let s:c_verbatim_tag         = '!<'.s:ns_uri_char.'\+>'
    "\     let s:c_named_tag_handle     = '!'.s:ns_word_char.'\+!'
    "\     let s:c_secondary_tag_handle = '!!'
    "\     let s:c_primary_tag_handle   = '!'
    "\     let s:c_tag_handle = '\%(' . s:c_named_tag_handle .
    "\         \         '\|' . s:c_secondary_tag_handle .
    "\         \         '\|' . s:c_primary_tag_handle . '\)'
    "\
    "\     let s:c_ns_shorthand_tag = s:c_tag_handle . s:ns_tag_char.'\+'
    "\     let s:c_non_specific_tag = '!'
    "\     let s:c_ns_tag_property = s:c_verbatim_tag.
    "\                             \        '\|'.s:c_ns_shorthand_tag.
    "\                             \        '\|'.s:c_non_specific_tag
    "\
    "\     let s:c_ns_anchor_name = s:c_ns_anchor_char.'\+'
    "\     let s:c_ns_anchor_property =  '&'.s:c_ns_anchor_name
    "\     let s:c_ns_alias_node      = '\*'.s:c_ns_anchor_name
    "\
    "\     let s:ns_directive_name = s:ns_char.'\+'
    "\
    "\     let s:ns_local_tag_prefix  = '!'.s:ns_uri_char.'*'
    "\     let s:ns_global_tag_prefix = s:ns_tag_char.s:ns_uri_char.'*'
    "\     let s:ns_tag_prefix = s:ns_local_tag_prefix.
    "\                             \    '\|'.s:ns_global_tag_prefix
    "\
    "\     let s:ns_plain_safe_out = s:ns_char
    "\     let s:ns_plain_safe_in  = '\%('.s:c_flow_indicator.'\@!'.s:ns_char.'\)'
    "\
    "\     let s:ns_plain_safe_in = substitute(s:ns_plain_safe_in, '\V\C\\%('.s:_collection.'\\@!'.s:_neg_collection.'\\)', '[^\1\2]', '')
    "\     let s:ns_plain_safe_in_without_colhash = substitute(s:ns_plain_safe_in, '\V\C'.s:_neg_collection, '[^\1:#]', '')
    "\     let s:ns_plain_safe_out_without_colhash = substitute(s:ns_plain_safe_out, '\V\C'.s:_neg_collection, '[^\1:#]', '')
    "\
    "\     let s:ns_plain_first_in  = '\%('.s:ns_char_without_c_indicator.'\|[?:\-]\%('.s:ns_plain_safe_in.'\)\@=\)'
    "\     let s:ns_plain_first_out = '\%('.s:ns_char_without_c_indicator.'\|[?:\-]\%('.s:ns_plain_safe_out.'\)\@=\)'
    "\
    "\     let s:ns_plain_char_in  = '\%('.s:ns_char.'#\|:'.s:ns_plain_safe_in.'\|'.s:ns_plain_safe_in_without_colhash.'\)'
    "\     let s:ns_plain_char_out = '\%('.s:ns_char.'#\|:'.s:ns_plain_safe_out.'\|'.s:ns_plain_safe_out_without_colhash.'\)'
    "\
    "\     let s:ns_plain_out = s:ns_plain_first_out . s:ns_plain_char_out.'*'
    "\     let s:ns_plain_in  = s:ns_plain_first_in  . s:ns_plain_char_in.'*'
    "\
    "\
    "\ syn keyword yamlTodo            contained TODO FIXME XXX NOTE
    "\
    "\ syn region  yamlComment         display oneline start=@\%\(^\|\s\)#@ end=@$@       contains=yamlTodo
    "\
    "\ exe  'syn region yamlDirective oneline start=' . string('^\ze%'.s:ns_directive_name.'\s\+').' '.
    "\                         \                            'end="$" '.
    "\                         \                            'contains=yamlTAGDirective,'.
    "\                         \                                     'yamlYAMLDirective,'.
    "\                         \                                     'yamlReservedDirective '.
    "\                         \                            'keepend'
    "\
    "\ syn match yamlTAGDirective '%TAG\s\+' contained nextgroup=yamlTagHandle
    "\ exe  'syn match yamlTagHandle contained nextgroup=yamlTagPrefix '.string(s:c_tag_handle.'\s\+')
    "\ exe  'syn match yamlTagPrefix contained nextgroup=yamlComment ' . string(s:ns_tag_prefix)
    "\
    "\ "\ 这个syntax/yaml.vim is for yaml1.2
    "\ syn match yamlYAMLDirective '%YAML\s\+'  contained nextgroup=yamlYAMLVersion
    "\ syn match yamlYAMLVersion   '\d\+\.\d\+' contained nextgroup=yamlComment
    "\
    "\ exe  'syn match yamlReservedDirective contained nextgroup=yamlComment '.
    "\                         \string('%\%(\%(TAG\|YAML\)\s\)\@!'.s:ns_directive_name)
    "\
    "\ syn region yamlFlowString matchgroup=yamlFlowStringDelimiter start='"' skip='\\"' end='"'
    "\                         \ contains=yamlEscape
    "\                         \ nextgroup=yamlKeyValueDelimiter
    "\
    "\ syn region yamlFlowString matchgroup=yamlFlowStringDelimiter start="'" skip="''"  end="'"
    "\                         \ contains=yamlSingleEscape
    "\                         \ nextgroup=yamlKeyValueDelimiter
    "\
    "\ syn match  yamlEscape contained '\\\%([\\"abefnrtv\^0_ NLP\n]\|x\x\x\|u\x\{4}\|U\x\{8}\)'
    "\ syn match  yamlSingleEscape contained "''"
    "\
    "\ syn match yamlBlockScalarHeader contained  #\s\+\zs[|>]\%([+-]\=[1-9]\|[1-9]\=[+-]\)\=#
    "\
    "\ syn cluster yamlConstant contains=yamlBool,yamlNull
    "\
    "\ syn cluster yamlFlow          contains=yamlFlowString,yamlFlowMapping,yamlFlowCollection
    "\     syn cluster yamlFlow      add=yamlFlowMappingKey,yamlFlowMappingMerge
    "\     syn cluster yamlFlow      add=@yamlConstant,yamlPlainScalar,yamlFloat
    "\     syn cluster yamlFlow      add=yamlTimestamp,yamlInteger,yamlMappingKeyStart
    "\     syn cluster yamlFlow      add=yamlComment
    "\
    "\ syn region yamlFlowMapping    matchgroup=yamlFlowIndicator start='{' end='}' contains=@yamlFlow
    "\ syn region yamlFlowCollection matchgroup=yamlFlowIndicator start='\[' end='\]' contains=@yamlFlow
    "\
    "\ exe  'syn match yamlPlainScalar /'.s:ns_plain_out.'/'
    "\ exe  'syn match yamlPlainScalar contained /'.s:ns_plain_in.'/'
    "\
    "\ syn match yamlMappingKeyStart '?\ze\s'
    "\ syn match yamlMappingKeyStart '?' contained
    "\
    "\ exe  'syn match yamlFlowMappingKey /\%#=1'.s:ns_plain_in.'\%(\s\+'.s:ns_plain_in.'\)*\ze\s*:/ contained '.
    "\                         \'nextgroup=yamlKeyValueDelimiter'
    "\
    "\ syn match yamlFlowMappingMerge /<<\ze\s*:/ contained nextgroup=yamlKeyValueDelimiter
    "\
    "\ syn match yamlBlockCollectionItemStart
    "\               \ '^\s*\zs-\%(\s\+-\)*\s'
    "\               \ nextgroup=yamlBlockMappingKey,yamlBlockMappingMerge
    "\
    "\                                  "\ Use the old regexp engine, the NFA engine doesn't like all the \@ items.
    "\                                  "\ 行首空格
    "\ exe  'syn match yamlBlockMappingKey   /\%#=1^\s*\zs'
    "\                                     \ . s:ns_plain_out
    "\                                     \ . '\%(\s\+'
    "\                                     \ .     s:ns_plain_out
    "\                                     \ . '\)*\ze\s*:\%(\s\|$\)/ '
    "\                         \ . 'nextgroup=yamlKeyValueDelimiter'
    "\
    "\ exe  'syn match yamlBlockMappingKey /\%#=1\s*\zs'
    "\                         \ .. s:ns_plain_out .. '\%(\s\+' .. s:ns_plain_out .. '\)*\ze\s*:\%(\s\|$\)/ contained '
    "\                         \ . 'nextgroup=yamlKeyValueDelimiter'
    "\
    "\ syn match yamlBlockMappingMerge /^\s*\zs<<\ze:\%(\s\|$\)/ nextgroup=yamlKeyValueDelimiter
    "\ syn match yamlBlockMappingMerge /<<\ze\s*:\%(\s\|$\)/ nextgroup=yamlKeyValueDelimiter contained
    "\
    "\ "\ 这行可以放到文件开头不?
    "\ syn match   yamlKeyValueDelimiter /\s*:/ contained
    "\                           "\ 空格可有可无
    "\                           "\ yamlKeyValueDelimiter 后面还要有一个空格?
    "\
    "\ syn cluster yamlScalarWithSpecials contains=yamlPlainScalar,yamlBlockMappingKey,yamlFlowMappingKey
    "\
    "\
    "\
    "\ let s:_bounder = s:SimplifyToAssumeAllPrintable('\%([[\]{}, \t]\@!\p\)')
    "\ if b:yaml_schema is# 'json'
    "\     syn keyword yamlNull null contained containedin=@yamlScalarWithSpecials
    "\     syn keyword yamlBool true false
    "\
    "\     exe 'syn match   yamlInteger /'.s:_bounder.'\@1<!\%(0\|-\=[1-9][0-9]*\)'.s:_bounder.'\@!/ contained containedin=@yamlScalarWithSpecials'
    "\
    "\     exe 'syn match   yamlFloat   /'.s:_bounder.'\@1<!\%(-\=[1-9][0-9]*\%(\.[0-9]*\)\=\(e[-+]\=[0-9]\+\)\=\|0\|-\=\.inf\|\.nan\)'
    "\                             \ . s:_bounder
    "\                                         \ . '\@!/ contained containedin=@yamlScalarWithSpecials'
    "\
    "\ elseif b:yaml_schema is# 'core'
    "\     syn keyword yamlNull null Null NULL contained containedin=@yamlScalarWithSpecials
    "\     syn keyword yamlBool true True TRUE false False FALSE contained containedin=@yamlScalarWithSpecials
    "\
    "\
    "\     exe 'syn match   yamlNull /'     . s:_bounder.'\@1<!\~'.s:_bounder.'\@!/ contained containedin=@yamlScalarWithSpecials'
    "\
    "\     "\ foo: 12345
    "\     "\ bar: 0x12d4     hex
    "\     "\ plop: ✗023332✗    octal  \ 这是yaml1.1的用法,   yaml1.2更新了:
    "\         "\ you need to specify such strings with 0o[0-7]+
    "\                                             e.g. "\ 0o7770
    "\
    "\     exe 'syn match   yamlInteger /'  .s:_bounder
    "\                              \ . '\@1<!\%([+-]\=\%(0\%(b[0-1_]\+\|[0-7_]\+\|x[0-9a-fA-F_]\+\)\=\|\%([1-9][0-9_]*\%(:[0-5]\=\d\)\+\)\)\|[1-9][0-9_]*\)'
    "\                              \ . s:_bounder
    "\                              \ . '\@!/ contained containedin=@yamlScalarWithSpecials'
    "\     "\ 支持指数
    "\     "\ bar:  12.3015e+05
    "\     exe 'syn match   yamlFloat /'   . s:_bounder
    "\                                  . '\@1<!\%([+-]\=\%(\%(\d[0-9_]*\)\.[0-9_]*\%([eE][+-]\=\d\+\)\=\|\.[0-9_]\+\%([eE][-+]\=[0-9]\+\)\=\|\d[0-9_]*\%(:[0-5]\=\d\)\+\.[0-9_]*\|\.\%(inf\|Inf\|INF\)\)\|\%(\.\%(nan\|NaN\|NAN\)\)\)'
    "\                             \ . s:_bounder
    "\                             \ . '\@!/ contained containedin=@yamlScalarWithSpecials'
    "\
    "\ elseif b:yaml_schema is# 'pyyaml'
    "\     syn keyword yamlNull null Null NULL contained containedin=@yamlScalarWithSpecials
    "\
    "\     syn keyword yamlBool
    "\     \ true
    "\     \ True
    "\     \ TRUE
    "\         \ false
    "\         \ False
    "\         \ FALSE
    "\     \ yes
    "\     \ Yes
    "\     \ YES
    "\         \ no
    "\         \ No
    "\         \ NO
    "\     \ on
    "\     \ On
    "\     \ ON
    "\         \ off
    "\         \ Off
    "\         \ OFF
    "\     \ contained
    "\     \ containedin=@yamlScalarWithSpecials
    "\
    "\     exe 'syn match   yamlNull /'.s:_bounder.'\@1<!\~'.s:_bounder.'\@!/ contained containedin=@yamlScalarWithSpecials'
    "\
    "\     exe 'syn match  yamlFloat /'.s:_bounder.'\@1<!\%(\v[-+]?%(\d[0-9_]*)\.[0-9_]*%([eE][-+]\d+)?|\.[0-9_]+%([eE][-+]\d+)?|[-+]?\d[0-9_]*%(\:[0-5]?\d)+\.[0-9_]*|[-+]?\.%(inf|Inf|INF)|\.%(nan|NaN|NAN)\m\)'.s:_bounder.'\@!/ contained containedin=@yamlScalarWithSpecials'
    "\
    "\     exe 'syn match  yamlInteger /'.s:_bounder.'\@1<!\%(\v[-+]?0b[0-1_]+|[-+]?0[0-7_]+|[-+]?%(0|[1-9][0-9_]*)|[-+]?0x[0-9a-fA-F_]+|[-+]?[1-9][0-9_]*%(:[0-5]?\d)+\m\)'.s:_bounder.'\@!/ contained containedin=@yamlScalarWithSpecials'
    "\
    "\     exe 'syn match  yamlTimestamp /'.s:_bounder.'\@1<!\%(\v\d\d\d\d\-\d\d\-\d\d|\d\d\d\d \-\d\d? \-\d\d?%([Tt]|[ \t]+)\d\d?\:\d\d \:\d\d %(\.\d*)?%([ \t]*%(Z|[-+]\d\d?%(\:\d\d)?))?\m\)'.s:_bounder.'\@!/ contained containedin=@yamlScalarWithSpecials'
    "\
    "\ elseif b:yaml_schema is# 'failsafe'
    "\         " Nothing
    "\ en
    "\ unlet s:_bounder
    "\
    "\
    "\ exe  'syn match yamlNodeTag ' . string(s:c_ns_tag_property)
    "\ exe  'syn match yamlAnchor  ' . string(s:c_ns_anchor_property)
    "\ exe  'syn match yamlAlias   ' . string(s:c_ns_alias_node)
    "\
    "\
    "\ "\ tutorial: 一个yaml文件 可以有多个Document
    "\ "\ A document starts with three dashes and ends with three periods.
    "\ syn match yamlDocumentStart '^---\ze\%(\s\|$\)'
    "\     "\ Java's Jackson will not process a YAML document without the start, but Python's PyYAML will
    "\ syn match yamlDocumentEnd   '^\.\.\.\ze\%(\s\|$\)'
    "\     "\ The end operator is usually optional.
    "\
    "\ "\ link
    "\     hi def link yamlTodo                     Todo
    "\     hi def link yamlComment                  Comment
    "\
    "\     hi def link yamlDocumentStart            PreProc
    "\     hi def link yamlDocumentEnd              PreProc
    "\
    "\     hi def link yamlDirectiveName            Keyword
    "\
    "\     hi def link yamlTAGDirective             yamlDirectiveName
    "\     hi def link yamlTagHandle                String
    "\     hi def link yamlTagPrefix                String
    "\
    "\     hi def link yamlYAMLDirective            yamlDirectiveName
    "\     hi def link yamlReservedDirective        Error
    "\     hi def link yamlYAMLVersion              Number
    "\
    "\     hi def link yamlString                   String
    "\     hi def link yamlFlowString               yamlString
    "\     hi def link yamlFlowStringDelimiter      yamlString
    "\     hi def link yamlEscape                   SpecialChar
    "\     hi def link yamlSingleEscape             SpecialChar
    "\
    "\     hi def link yamlBlockCollectionItemStart Label
    "\     hi def link yamlBlockMappingKey          Identifier
    "\     hi def link yamlBlockMappingMerge        Special
    "\
    "\     hi def link yamlFlowMappingKey           Identifier
    "\     hi def link yamlFlowMappingMerge         Special
    "\
    "\     hi def link yamlMappingKeyStart          Special
    "\     hi def link yamlFlowIndicator            Special
    "\     hi def link yamlKeyValueDelimiter        Special
    "\
    "\     hi def link yamlConstant                 Constant
    "\
    "\     hi def link yamlNull                     yamlConstant
    "\     hi def link yamlBool                     yamlConstant
    "\
    "\     hi def link yamlAnchor                   Type
    "\     hi def link yamlAlias                    Type
    "\     hi def link yamlNodeTag                  Type
    "\
    "\     hi def link yamlInteger                  Number
    "\     hi def link yamlFloat                    Float
    "\     hi def link yamlTimestamp                Number
    "\
    "\ let b:current_syntax = "yaml"
    "\
    "\ unlet
    "\     \ s:ns_word_char
    "\     \ s:ns_uri_char
    "\     \ s:c_verbatim_tag
    "\     \ s:c_named_tag_handle
    "\     \ s:c_secondary_tag_handle
    "\     \ s:c_primary_tag_handle
    "\     \ s:c_tag_handle
    "\     \ s:ns_tag_char
    "\     \ s:c_ns_shorthand_tag
    "\     \ s:c_non_specific_tag
    "\     \ s:c_ns_tag_property
    "\     \ s:c_ns_anchor_char
    "\     \ s:c_ns_anchor_name
    "\     \ s:c_ns_anchor_property
    "\     \ s:c_ns_alias_node
    "\     \ s:ns_char
    "\     \ s:ns_directive_name
    "\     \ s:ns_local_tag_prefix
    "\     \ s:ns_global_tag_prefix
    "\     \ s:ns_tag_prefix
    "\     \ s:c_indicator
    "\     \ s:ns_plain_safe_out
    "\     \ s:c_flow_indicator
    "\     \ s:ns_plain_safe_in
    "\     \ s:ns_plain_first_in
    "\     \ s:ns_plain_first_out
    "\     \ s:ns_plain_char_in
    "\     \ s:ns_plain_char_out
    "\     \ s:ns_plain_out
    "\     \ s:ns_plain_in
    "\     \ s:ns_char_without_c_indicator
    "\     \ s:ns_plain_safe_in_without_colhash
    "\     \ s:ns_plain_safe_out_without_colhash
    "\
    "\ unlet s:_collection s:_neg_collection
    "\
    "\ delfunction s:SimplifyAdjacentCollections
    "\ delfunction s:SimplifyToAssumeAllPrintable
    "\
    "\ let &cpo = s:cpo_save
    "\ unlet s:cpo_save
