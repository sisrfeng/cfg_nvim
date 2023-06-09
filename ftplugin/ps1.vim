" Vim filetype plugin file
" Language:    Windows PowerShell
" URL:         https://github.com/PProvost/vim-ps1
" Last Change: 2021 Apr 02

if exists("b:did_ftplugin") | finish | endif   | let b:did_ftplugin = 1

let s:cpo_save = &cpo  | set cpo&vim

setl  textwidth=0
setl  commentstring=#%s
setl  formatoptions=tcqro

" Enable autocompletion of hyphenated PowerShell commands,
" e.g. Get-Content or Get-ADUser
setl  iskeyword+=-

"\ PowerShell files for all versions are .ps1 (or .psm1, .psd1, etc.).
"\ https://stackoverflow.com/questions/62604621/what-are-the-different-powershell-file-types
" Change the browse dialog on Win32 to show mainly PowerShell-related files
if has("gui_win32")
	let b:browsefilter =
        \ "All PowerShell Files (*.ps1, *.psd1, *.psm1, *.ps1xml)\t*.ps1;*.psd1;*.psm1;*.ps1xml\n" .
        \ "PowerShell Script Files (*.ps1)\t*.ps1\n" .
        \ "PowerShell Module Files (*.psd1, *.psm1)\t*.psd1;*.psm1\n" .
        \ "PowerShell XML Files (*.ps1xml)\t*.ps1xml\n" .
        \ "All Files (*.*)\t*.*\n"
en

" Look up keywords by Get-Help:
" check for PowerShell Core in Windows, Linux or MacOS
    if executable('pwsh') | let s:pwsh_cmd = 'pwsh'
    " on Windows Subsystem for Linux, check for PowerShell Core in Windows
    elseif exists('$WSLENV') && executable('pwsh.exe') | let s:pwsh_cmd = 'pwsh.exe'
    " check for PowerShell <= 5.1 in Windows
    elseif executable('powershell.exe') | let s:pwsh_cmd = 'powershell.exe'
    en

if exists('s:pwsh_cmd')
    if !has('gui_running') && executable('less') &&
            \ !(exists('$ConEmuBuild') && &term =~? '^xterm')
        " For exclusion of ConEmu, see https://github.com/Maximus5/ConEmu/issues/2048
        com!  -buffer -nargs=1 GetHelp silent exe '!' . s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full "<args>" | ' . (has('unix') ? 'LESS= less' : 'less') | redraw!
    elseif has('terminal')
        com!  -buffer -nargs=1 GetHelp silent exe 'term ' . s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full "<args>"' . (executable('less') ? ' | less' : '')
    el
        com!  -buffer -nargs=1 GetHelp echo system(s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full <args>')
    en
en
setl  keywordprg=:GetHelp

" Undo the stuff we changed
let b:undo_ftplugin = "setl  tw< cms< fo< iskeyword< keywordprg<" .
			\ " | unlet! b:browsefilter"

let &cpo = s:cpo_save  | unlet s:cpo_save
