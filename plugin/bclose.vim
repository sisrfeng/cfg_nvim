" Delete buffer while keeping window layout (don't close buffer's windows).

    "\ Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
    "\
    "\ I found it on http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window and
    "\
    "\ The reason for adding it here is to be able to add it to an existing Janus bundle
    "\ (look at https://github.com/carlhuda/janus for instructions on how to do that)
if v:version < 700 || exists('loaded_bclose') || &cp
    finish
en
let loaded_bclose = 1
if !exists('bclose_multiple')
    let bclose_multiple = 1
en

" Display an error message.
fun! s:Warn(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl NONE
endf

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^)
" if it exists,
" or the previous buffer (:bp),
" or a blank buffer if no previous.
" Command ':Bclose!' is the same,
" but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
fun! s:Bclose(bang, buffer)
    if empty(a:buffer)
        let btarget = bufnr('%')
    elseif a:buffer =~ '^\d\+$'
        let btarget = bufnr(str2nr(a:buffer))
    el
        let btarget = bufnr(a:buffer)
    en
    if btarget < 0
        call s:Warn('No matching buffer for '.a:buffer)
        return
    en
    if empty(a:bang) && getbufvar(btarget, '&modified')
        call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
        return
    en
    " Numbers of windows that view target buffer which we will delete.
    let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
    if !g:bclose_multiple && len(wnums) > 1
        call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
        return
    en
    let wcurrent = winnr()
    for w in wnums
        exe  w.'wincmd w'
        let prevbuf = bufnr('#')
        if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
            buffer #
        el
            bprevious
        en
        if btarget == bufnr('%')
            " Numbers of listed buffers which are not the target to be deleted.
            let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
            " Listed, not target, and not displayed.
            let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
            " Take the first buffer, if any (could be more intelligent).
            let bjump = (bhidden + blisted + [-1])[0]
            if bjump > 0
                exe  'buffer '.bjump
            el
                exe  'enew'.a:bang
            en
        en
    endfor
    exe  'bdelete'.a:bang.' '.btarget
    exe  wcurrent.'wincmd w'
endf
com!  -bang -complete=buffer -nargs=? Bclose call <SID>Bclose('<bang>', '<args>')

if exists ("g:bclose_no_plugin_maps") &&  g:bclose_no_plugin_maps
        "do nothing
elseif exists ("g:no_plugin_maps") &&  g:no_plugin_maps
        "do nothing
el
         nno  <silent> <Leader>bd :Bclose<CR>
en


