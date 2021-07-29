filetype on
filetype plugin indent on
syntax on

let g:polyglot_disabled = ['markdown.plugin', 'pandoc.plugin', 'rust.plugin', 'typescript.plugin', 'javascript.plugin', 'html.plugin', 'css.plugin', 'scss.plugin', 'yaml.plugin', 'vim.plugin']

lua require('init')

set noswapfile
set undofile
set undodir="$HOME/.local/share/nvim/undodir"
set undolevels=100
set undoreload=1000
set updatetime=300

let g:startify_custom_header = startify#fortune#cowsay('', '═','║','╔','╗','╝','╚')
let g:startify_lists = [
            \ { 'type': 'sessions',  'header': ['   Sessions']             },
            \ { 'type': 'dir',       'header': ['   Recent in '. getcwd()] },
            \ { 'type': 'files',     'header': ['   Recent']               },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']            },
            \ { 'type': 'commands',  'header': ['   Commands']             },
            \ ]

" get highlight under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" autocommands
augroup auto_commands
    autocmd!
    autocmd BufEnter * checktime
    autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
    autocmd CursorHold,InsertLeave * nested call AutoSave()
    autocmd FileType markdown,pandoc call SetupMarkdown()
augroup END

" base00
hi! Conceal                     ctermbg=0
hi! Cursor          ctermfg=0
hi! PmenuSbar       ctermfg=0   ctermbg=0       cterm=none
hi! CustomRedPillInside cterm=bold gui=bold ctermfg=0 guifg=0
hi! CustomYellowPillInside cterm=bold gui=bold ctermfg=0 guifg=0
hi! CustomLimePillInside cterm=bold gui=bold ctermfg=0 guifg=0
hi! CustomAquaPillInside cterm=bold gui=bold ctermfg=0 guifg=0
hi! CustomBluePillInside cterm=bold gui=bold ctermfg=0 guifg=0
hi! CustomFuchsiaPillInside cterm=bold gui=bold ctermfg=0 guifg=0
hi! VirtualText                 ctermbg=none    cterm=italic

" base01
hi! ColorColumn                 ctermbg=8       cterm=none
hi! CursorColumn                ctermbg=8       cterm=none
hi! CursorLine                  ctermbg=8       cterm=none
hi! CursorLineNr                ctermbg=8       cterm=bold
hi! IncSearch       ctermfg=8                   cterm=none
hi! PMenuSel        ctermfg=8                   cterm=bold
hi! QuickFixLine                ctermbg=8       cterm=none
hi! Substitute      ctermfg=8                   cterm=none
hi! TabLineSel                  ctermbg=8       cterm=none
hi! TabLine                     ctermbg=8       cterm=none
hi! TabLineFill                 ctermbg=8       cterm=none
hi! PMenu                       ctermbg=8       cterm=none
hi! MatchParen                  ctermbg=8       cterm=bold
hi! Todo                        ctermbg=8       cterm=bold,italic
hi! Folded                      ctermbg=8
hi! CustomGrayPillOutside ctermfg=8 guifg=8 ctermbg=none guibg=none
hi! CustomGrayPillInside cterm=italic gui=italic ctermbg=8 guibg=8
hi! CustomGrayPillInsideTrueGreenFg cterm=bold gui=bold ctermbg=8 guibg=8 ctermfg=48 guifg=48
hi! CustomGrayPillInsideTrueRedFg cterm=bold gui=bold ctermbg=8 guibg=8 ctermfg=196 guifg=196
hi! CustomClosePillInside cterm=bold gui=bold ctermbg=8 guibg=8

" base02
hi! IncSearch                   ctermbg=10      cterm=none
hi! Search          ctermfg=10
hi! StatusLine      ctermfg=10  ctermbg=none    cterm=underline
hi! StatusLineNC    ctermfg=10  ctermbg=none    cterm=underline
hi! VertSplit       ctermfg=10  ctermbg=none    cterm=none
hi! Visual                      ctermbg=10
hi! Whitespace      ctermfg=10

" base03
hi! Comment         ctermfg=11
hi! Conceal         ctermfg=11
hi! Folded          ctermfg=11
hi! LineNr          ctermfg=11  ctermbg=none    cterm=none
hi! NonText         ctermfg=11
hi! SpecialKey      ctermfg=11
hi! TabLine         ctermfg=11                  cterm=none
hi! TabLineFill     ctermfg=11                  cterm=none
hi! VirtualText     ctermfg=11                  cterm=italic

" base04
hi! CursorLineNr    ctermfg=7                   cterm=bold
hi! CustomGrayPillInside cterm=italic gui=italic ctermfg=7 guifg=7

" base05
hi! Cursor                      ctermbg=15
hi! Normal          ctermfg=15  ctermbg=none
hi! Operator        ctermfg=15                  cterm=none
hi! PMenu           ctermfg=15                  cterm=none
hi! PMenuThumb      ctermfg=15  ctermbg=15      cterm=none
hi! PMenuSel                    ctermbg=15      cterm=bold

" base06
" nothing here!

" base07
hi! MatchParen      ctermfg=13                  cterm=bold
hi! Visual          ctermfg=13

" base08
hi! Character       ctermfg=1
hi! Debug           ctermfg=1
hi! Exception       ctermfg=1
hi! Identifier      ctermfg=1                  cterm=none
hi! Macro           ctermfg=1
hi! TooLong         ctermfg=1
hi! Underlined      ctermfg=1
hi! VisualNOS       ctermfg=1
hi! WarningMsg      ctermfg=1
hi! WildMenu        ctermfg=1
hi! Statement       ctermfg=1
hi! CustomClosePillInside cterm=bold ctermfg=1
hi! CustomRedPillInside cterm=bold gui=bold ctermbg=1 guibg=1
hi! CustomRedPillOutside ctermfg=1 guifg=1 ctermbg=none guibg=none

" base09
hi! Boolean         ctermfg=9
hi! Constant        ctermfg=9
hi! Float           ctermfg=9
hi! Number          ctermfg=9
hi! CustomClosePillInside cterm=bold gui=bold ctermbg=8 guibg=8

" base0A
hi! Label           ctermfg=3
hi! PreProc         ctermfg=3
hi! Todo            ctermfg=3                  cterm=bold,italic
hi! Type            ctermfg=3                  cterm=none
hi! Typedef         ctermfg=3
hi! Repeat          ctermfg=3
hi! Tag             ctermfg=3
hi! StorageClass    ctermfg=3
hi! Substitute                  ctermbg=3      cterm=none
hi! Search                      ctermbg=3
hi! CustomYellowPillInside cterm=bold gui=bold ctermbg=3 guibg=3 ctermfg=0 guifg=0
hi! CustomYellowPillOutside ctermfg=3 guifg=3 ctermbg=none guibg=none

" base0B
hi! ModeMsg         ctermfg=2
hi! MoreMsg         ctermfg=2
hi! String          ctermfg=2
hi! TabLineSel      ctermfg=2                  cterm=none
hi! CustomLimePillInside cterm=bold gui=bold ctermbg=2 guibg=2
hi! CustomLimePillOutside ctermfg=2 guifg=2 ctermbg=none guibg=none

" base0C
hi! FoldColumn      ctermfg=6
hi! Special         ctermfg=6
hi! CustomAquaPillInside cterm=bold gui=bold ctermbg=6 guibg=6
hi! CustomAquaPillOutside ctermfg=6 guifg=6 ctermbg=none guibg=none

" base0D
hi! Directory       ctermfg=4
hi! Function        ctermfg=4
hi! Include         ctermfg=4
hi! Question        ctermfg=4
hi! Title           ctermfg=4                  cterm=none
hi! CustomBluePillInside cterm=bold gui=bold ctermbg=4 guibg=4
hi! CustomBluePillOutside ctermfg=4 guifg=4 ctermbg=none guibg=none

" base0E
hi! Define          ctermfg=5                  cterm=none
hi! Keyword         ctermfg=5
hi! Structure       ctermfg=5
hi! CustomFuchsiaPillInside cterm=bold gui=bold ctermbg=5 guibg=5 ctermfg=0 guifg=0
hi! CustomFuchsiaPillOutside ctermfg=5 guifg=5 ctermbg=none guibg=none

" base0F
hi! Conditional     ctermfg=14
hi! Delimiter       ctermfg=14
hi! SpecialChar     ctermfg=14

" errors, warnings, info
hi! Error guibg=none ctermbg=none guifg=red ctermfg=196 gui=bold cterm=bold
hi! Warning guibg=none ctermbg=none guifg=yellow ctermfg=226 gui=bold cterm=bold
hi! Info guibg=none ctermbg=none guifg=cyan ctermfg=51 gui=bold cterm=bold
hi! link ErrorMsg Error
hi! link WarningMsg Warning
hi! link InfoMsg Info

" LSP highlights
hi! link LspDiagnosticsDefaultError Error
hi! link LspDiagnosticsDefaultHint Info
hi! link LspDiagnosticsDefaultInformation Info
hi! link LspDiagnosticsDefaultWarning Warning
hi! link LspDiagnosticsUnderlineError Error
hi! link LspDiagnosticsUnderlineHint Info
hi! link LspDiagnosticsUnderlineInformation Info
hi! link LspDiagnosticsUnderlineWarning Warning
hi! link LspDiagnosticsVirtualTextError Error
hi! link LspDiagnosticsVirtualTextHint Info
hi! link LspDiagnosticsVirtualTextInformation Info
hi! link LspDiagnosticsVirtualTextWarning Warning
hi! link LspDiagnosticsErrorSign Error
hi! link LspDiagnosticsHintSign Info
hi! link LspDiagnosticsInformationSign Info
hi! link LspDiagnosticsWarningSign Warning

" diff highlights
hi! DiffAdd ctermbg=none guibg=none ctermfg=48 guifg=green
hi! DiffChange ctermbg=none guibg=none ctermfg=214 guifg=orange
hi! DiffDelete ctermbg=none guibg=none ctermfg=196 guifg=red
hi! DiffText ctermbg=none guibg=none ctermfg=214 guifg=orange cterm=undercurl gui=undercurl
hi! link GitGutterAdd DiffAdd
hi! link GitGutterChange DiffChange
hi! link GitGutterDelete DiffDelete

" spell highlights
hi! SpellBad ctermfg=196 ctermbg=none guifg=196 guibg=none cterm=italic,undercurl gui=italic,undercurl
hi! SpellCap ctermfg=201 ctermbg=none guifg=201 guibg=none
hi! SpellRare ctermfg=214 ctermbg=none guifg=214 guibg=none cterm=italic gui=italic
hi! link SpellLocal SpellRare

" other highlights
hi! link NvimInternalError Error
hi! link javaScriptLineComment Comment
hi! Bold                                        cterm=bold
hi! FoldColumn                  ctermbg=none
hi! Italic                                      cterm=italic
hi! SignColumn                  ctermbg=none

" signs
sign define LspDiagnosticsSignError text=X texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text=! texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text=i texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text=? texthl=LspDiagnosticsSignHint linehl= numhl=
call sign_define("LspDiagnosticsErrorSign", {"text" : "X", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "!", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "i", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "?", "texthl" : "LspDiagnosticsHint"})

fu! UpdateGitInfo()
    let b:custom_git_branch = ''
    try
        if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
            b:custom_git_branch = fugitive#head
        endif
    catch
    endtry
    return b:custom_git_branch
endfu

fu! MarkdownFoldText()
    let linetext = getline(v:foldstart)
    let txt = linetext . ' [...] '
    return txt
endfunction

fu! SetupMarkdown()
    setlocal noexpandtab
    setlocal tw=30
    setlocal shiftwidth=4
    setlocal tabstop=4
    setlocal foldtext=MarkdownFoldText()
    setlocal spell
    let b:table_mode_corner='+'
endfunction

fu! AutoSave()
    silent! wa
endfunction

"" Status bar



let g:currentmode={
    \ 'n'  : 'n',
    \ 'no' : '.',
    \ 'v'  : 'v',
    \ 'V'  : 'vl',
    \ '^V' : 'vb',
    \ 's'  : 's',
    \ 'S'  : 'sl',
    \ '^S' : 'sb',
    \ 'i'  : 'i',
    \ 'R'  : 'r',
    \ 'Rv' : 'vr',
    \ 'c'  : ':',
    \ 'cv' : 'xv',
    \ 'ce' : 'x',
    \ 'r'  : 'p',
    \ 'rm' : 'm',
    \ 'r?' : '?',
    \ '!'  : '!',
    \ 't'  : 't'
    \ }

fu! CurrentMode() abort
    let l:modecurrent = mode()
    " use get() -> fails safely, since ^V doesn't seem to register. 3rd arg is
    " used when return of mode() == 0, which is the case with ^V.
    " thus, ^V fails -> returns 0 -> replaced with 'V Block'
    let l:modelist = tolower(get(g:currentmode, l:modecurrent, 'vb'))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction

fu! PasteMode()
    let paste_status = &paste
    if paste_status == 1
        return "paste"
    else
        return ""
    endif
endfunction

set laststatus=2
set noshowmode
set statusline=%!ActiveStatus()
set tabline=%!TabLine()

fu! LspCustomStatus() abort
    if luaeval('#vim.lsp.buf_get_clients() > 0')
        return luaeval("require('lsp-status').status()")
    endif

    return ''
endfunction

fu! ActiveStatus()
    " PILLS! 

    let l:space = '%#StatusLine#  '
    let l:s = ''

    let l:lsp_status = trim(LspCustomStatus())
    if len(l:lsp_status) > 0
        let l:s .= "%#CustomGrayPillOutside#"
        let l:s .= "%#CustomGrayPillInside#" . l:lsp_status
        let l:s .= "%#CustomGrayPillOutside#"
    endif

    " right-align everything after this
    let l:s .= "%#StatusLine#%="

    if &modified || &readonly || !&modifiable
        let l:s .= "%#CustomGrayPillOutside#"
        if &modified && (&readonly || !&modifiable)
            let l:s .= "%#CustomGrayPillInsideTrueRedFg# +"
        elseif &modified
            let l:s .= "%#CustomGrayPillInsideTrueGreenFg#+"
        else
            let l:s .= "%#CustomGrayPillInsideTrueRedFg#"
        endif
        let l:s .= "%#CustomGrayPillOutside#"
    endif

    let l:s .= l:space
    let l:s .= "%#CustomBluePillOutside#"
    let l:s .= "%#CustomBluePillInside#%p%%"
    let l:s .= "%#CustomBluePillOutside#"

    let l:s .= l:space
    let l:s .= "%#CustomAquaPillOutside#"
    let l:s .= "%#CustomAquaPillInside#%l:%2c"
    let l:s .= "%#CustomAquaPillOutside#"

    let l:s .= l:space
    let l:s .= "%#CustomLimePillOutside#"
    let l:s .= "%#CustomLimePillInside#".tolower(&ft)
    let l:s .= "%#CustomLimePillOutside#"

    if fugitive#head()!=''
        let l:s .= l:space
        let l:s .= "%#CustomYellowPillOutside#"
        let l:s .= "%#CustomYellowPillInside#"." ".fugitive#head()
        let l:s .= "%#CustomYellowPillOutside#"
    endif

    let l:s .= l:space
    let l:s .= "%#CustomRedPillOutside#"
    let l:s .= "%#CustomRedPillInside#"
    let l:s .= "%f"
    let l:s .= "%#CustomRedPillOutside#"

    let l:s .= l:space
    let l:s .= "%#CustomFuchsiaPillOutside#"
    let l:s .= "%#CustomFuchsiaPillInside#%{CurrentMode()}\%-6{PasteMode()}"
    let l:s .= "%#CustomFuchsiaPillOutside#"

    return l:s
endfunction

fu! InactiveStatus()
    let l:s="%="
    let l:s .= "%#CustomGrayPillOutside#"
    let l:s .= "%#CustomGrayPillInside#"
    let l:s .= "%f  %p%%"
    let l:s .= "%#CustomGrayPillOutside#"
    return l:s
endfunction

augroup status
    autocmd!
    autocmd BufEnter,WinEnter,BufRead,BufWinEnter * :setlocal statusline=%!ActiveStatus()
    autocmd BufLeave,WinLeave * :setlocal statusline=%!InactiveStatus()
augroup END

"" Tab line

fu! TabLine()
    let l:s = ''
    let l:space = '  '
    for i in range(tabpagenr('$'))
        let tabnr = i + 1 " range() starts at 0
        let winnr = tabpagewinnr(tabnr)
        let buflist = tabpagebuflist(tabnr)
        let bufnr = buflist[winnr - 1]
        let bufname = fnamemodify(bufname(bufnr), ':t')

        let l:s .= l:space . '%' . tabnr . 'T'

        " opening pill end
        if tabnr == tabpagenr()
            let l:s .= "%#CustomAquaPillOutside#"
            let l:s .= "%#CustomAquaPillInside#"
        else
            let l:s .= "%#CustomGrayPillOutside#"
            let l:s .= "%#CustomGrayPillInside#"
        endif

        " add mod identifier
        let bufmodified = getbufvar(bufnr, "&mod")
        if bufmodified
            let l:s .= '+ '
        endif

        " add file name
        let l:s .= empty(bufname) ? '[No Name]' : bufname

        " closing pill end
        if tabnr == tabpagenr()
            let l:s .= "%#CustomAquaPillOutside#"
        else
            let l:s .= "%#CustomGrayPillOutside#"
        endif
    endfor

    " after the last tab, fill with TabLineFill and reset tab page nr
    let l:s .= '%#TabLineFill#%T'

    " right-align the 'X' button
    if tabpagenr('$') > 1
        let l:s .= "%=%#CustomGrayPillOutside#"
        let l:s .= "%#CustomClosePillInside#"
        let l:s .= '%999XX'
        let l:s .= "%#CustomGrayPillOutside# "
    endif

    return s
endfunction

" sudo write
com! -bar W exe 'w !sudo tee >/dev/null %:p:S' | setl nomod
