" Compatibility and Dynamic Python {{{
set nocompatible
if has('python3') " if dynamic py|py3 support is enabled, this line already activates python 3.
  let s:python_version = 3
elseif has('python')
  let s:python_version = 2
else
  let s:python_version = 0
endif
let g:UltiSnipsUsePythonVersion = s:python_version 
" echomsg 'Using python'.s:python_version
" }}}
" Section: Basic Options {{{
set expandtab
set autowrite
set showmode
set foldmethod=marker
set showtabline=2
set guioptions-=e "recommended by flagship
set ignorecase smartcase
set shiftround
set showcmd ruler laststatus=2
set showmatch
set autoindent
set splitright
set smartindent
set wrap
set scrolloff=5
set cursorline cursorcolumn
set foldopen+=jump
set display=lastline "give it a try
set noshowmode
set lazyredraw
if has("linebreak")
  " dont break in the middle of a word
  set linebreak
  " ident line breaks
  if exists('+breakindent')
    set breakindent showbreak=\ +
  endif
endif
set nolist
set number relativenumber
set visualbell
set listchars=eol:¶,tab:¦-,trail:±,extends:»,precedes:«,nbsp:¬
" better default comment string for a lot of configuratoin files
set commentstring=#\ %s
set noruler
set dictionary+=/usr/share/dict/words
set thesaurus+=$HOME/.vim/thesaurus/words.txt
" %=%-14.(%l,%c%V%)\ %P
if has('persistent_undo')
  set undofile	" keep an undo file (undo changes after closing)
endif
set hlsearch incsearch

" wild menu
set wildmenu
set wildignore+=*/.git/*
set wildignore+=*.js,*.map
set wildignore+=tags,.*.un~,*.pyc
set wildignore+=*.bbl,*.aux,*.lot,*.lof,*.bcf,*.soc,*.fdb_latexmk,*.out,*.pdf
set wildmode=longest:full,full
set wildcharm=<C-z>

let g:tex_flavor = 'latex'
let g:is_bash = 1

augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END


" more complex options
set complete-=i
set complete+=d
set completeopt+=menuone,noinsert,noselect,longest
let g:mucomplete#enable_auto_at_startup = 1
" see :help fo-table
set formatoptions=rqn1j


" vim8 specific
if v:version >= 800
  set signcolumn=yes
endif

" Plugin Replacement
set path+=**



" }}}
" Section: Statusline {{{
" this is hacky to fix with to 2
set statusline=%#WarningMsg#%-2.2(%M\ %)%*
set statusline+=%#CursorLineNr#%4.4(%c%)%*
" buffer number and modified
set statusline+=[b%n\ %f%(\ *%{fugitive#head()}%)]
" file
" usual stuff
set statusline+=\ %H%R
set statusline+=%=
set statusline+=%a
set statusline+=\ @\ %P
let s:hl_as_usual = {"hl": ['Statusline', 'StatusLineNC']}
augroup my_flagship
  au!
  autocmd User Flags call Hoist("window", +10, {"hl": 'WarningMsg'}, 'SyntasticStatuslineFlag')
  autocmd User Flags call Hoist("window", -10, s:hl_as_usual, "%{tagbar#currenttag('[%s]', '')}")
  autocmd User Flags call Hoist("buffer", -10, s:hl_as_usual, "[%{&formatoptions}]")
  " autocmd User Flags call Hoist("buffer", 0, hl_as_usual, '%{g:asyncrun_status}')
  autocmd User Flags call Hoist("global", 0, s:hl_as_usual, "[%{&cpoptions}]")
  " this is necessary because (vim-signify|vim-gitgutter) somehow breaks colors
  " autocmd User Flags call Hoist("buffer", -10, hl_as_usual, function('fugitive#statusline'))
augroup END
" }}}
" Section: Maps {{{
if has('conceal')
  set conceallevel=2 concealcursor=
endif

let mapleader = ","
let maplocalleader = "\\"
inoremap <C-C> <Esc>`^

inoremap <C-j> <Esc>o

" zvzz
nnoremap n nzvzz
nnoremap N Nzvzz

" movement
map <Tab> %
map Y y$
nnoremap H ^
nnoremap L $

xnoremap <Space> I<Space><Esc>gv
xmap < <gv
xmap > >gv
" modes no scrolling frmo some strange input pad
nmap <Up> <nop>
nmap <Down> <nop>
nmap <Left> <nop>
nmap <Right> <nop>
" Convenience
nnoremap <Space> za
nnoremap <C-S> :w<cr>

" thanks to the pope
inoremap <C-X>^ <C-R>=substitute(&commentstring,' \=%s\>'," -*- ".&ft." -*- vim:set ft=".&ft." ".(&et?"et":"noet")." sw=".&sw." sts=".&sts.':','')<CR>


" i dont need multiple cursors
xnoremap <C-S> :s/


" Tpope's align gist
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
"
" The following is one mapping for all: 
" - Visual selection: :w skel/<filename> will create a grave
" - Reanimating skeletons by :r skel/<filename>
" - Editing a skeleton... :e skel/filename
cabbrev skel $HOME/.vim/graveyard

" After searching for the rune markers, you can replace as follows:
" navigate through them via n/N as usual,
let g:surround_{char2nr('m')} = "<++\r++>"
let g:surround_{char2nr('M')} = "<++\n\r\n++>"

" F keys {{{
nmap <F2> :20Lex<CR>
nmap <F3> :if exists(':TagbarToggle')<Bar>:TagbarToggle<Bar>endif<CR>
augroup f4_key
  au!
  au User VimtexEventInitPost nmap <buffer> <F4> <plug>(vimtex-toc-toggle)
  au FileType pandoc if exists(':TOC') | nmap <buffer> <F4> :TOC<CR> | endif
augroup END
" Tpope's fkeys are cool
nmap <silent> <F6> :if &previewwindow<Bar>pclose<Bar>elseif exists(':Gstatus')<Bar>exe 'Gstatus'<Bar>else<Bar>ls<Bar>endif<CR>
nmap <silent> <F7> :if exists(':Lcd')<Bar>exe 'Lcd'<Bar>elseif exists(':Cd')<Bar>exe 'Cd'<Bar>else<Bar>lcd %:h<Bar>endif<CR>
map <F8>    :Make<CR>
map <F9>    :Dispatch<CR>
map <F10>   :Start<CR>
" }}}

" Title case
nnoremap <Leader>tc :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR>:nohlsearch<CR>

"Quick access
nnoremap <leader>vv :Vedit vimrc<cr>

" Pythonic constructor
nnoremap <leader>c 0f(3wyt)o<ESC>pV:s/\([a-z_]\+\),\?/self.\1 = \1<C-v><CR>/g<CR>ddV?def<CR>j
"}}}
" Section: Text Objects {{{ "
" Pipe tables
" Complements cucumbertables.vim by tpope
" inoremap <Bar>-<Bar> <Esc>kyyp:s/\v[^<Bar>]/-/g<CR>:nohlsearch<CR>j

" test object for table cells
onoremap i<Bar> :<c-u>normal! T<Bar>vt<Bar><cr>
onoremap a<Bar> :<c-u>normal! F<Bar>vf<Bar><cr>

" motion for table cells, yes it keeps highlight :)
" positive formulation: Automatically detects when user is moving inside
" a bar table and highlights delimiters.
nnoremap <Bar> /<Bar><CR>

" |asdf|asdf|sadf asdf

" }}} Section: Text Objects "
" Section: Commands {{{
" command! -complete=packadd -nargs=1 Packadd packadd <args> | write | edit %
command! -bar -bang -complete=packadd -nargs=1 Packadd packadd<bang> <args> | doautoall BufRead
command! -bar -nargs=0 Helptags silent! helptags ALL
" }}}
" Section: Autocmds {{{
if has("autocmd")
  filetype plugin indent on
  augroup veight
    au!
    " q enough
    autocmd FileType help nnoremap <buffer> q :q!<cr>
    " as recommended to not write ugly mails for others
    autocmd FileType mail setlocal formatoptions+=aw
    " make useful dispatch
    autocmd FileType pandoc if exists(':Pandoc') | let b:dispatch=":Pandoc pdf" | endif
    autocmd FileType pandoc,markdown setlocal et sw=4 sts=2 iskeyword+=@,-,#
    autocmd FileType dot let b:dispatch="dot -Tpdf -o %:r.pdf %"  | setlocal commentstring=//%s
    " guess the dispatch by shebang
    autocmd BufReadPost * if getline(1) =~# '^#!' | let b:dispatch = getline(1)[2:-1] . ' %' | let b:start = b:dispatch | endif

    autocmd FileType html setlocal foldmethod=marker foldmarker=<div,/div> iskeyword+=-
    " if exists("+omnifunc")
    "   autocmd FileType * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    " endif
    autocmd FileType tex syn sync minlines=100 maxlines=300
          \ | let b:surround_{char2nr('x')} = "\\texttt{\r}"
          \ | let b:surround_{char2nr('c')} = "\\\1identifier\1{\r}"
          \ | let b:surround_{char2nr('e')} = "\\begin{\1environment\1}\n\r\n\\end{\1\1}"
          \ | let b:surround_{char2nr('v')} = "\\verb|\r|"
          \ | let b:surround_{char2nr('V')} = "\\begin{verbatim}\n\r\n\\end{verbatim}"
    autocmd FileType tex,mail,pandoc if exists(':Thesaurus') | setlocal keywordprg=:Thesaurus | endif
    " autocmd FileType pandoc nnoremap <buffer> <Leader>eb 
    autocmd FileType python setlocal textwidth=79 colorcolumn=+1 softtabstop=4 shiftwidth=4 expandtab
  augroup END
endif
" }}}
" Section: Plugins {{{
" Markdown {{{
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
" }}}
" Autopairs {{{
let g:AutoPairsMapCh = 0
" }}}
" ack {{{
let g:ack_use_dispatch = 1
" }}}
" pep8 indent {{{
let g:python_pep8_indent_multiline_string = 1
" }}}
" Ragtag {{{
let g:ragtag_global_maps = 1
" }}}
" Vimtex {{{
let g:vimtex_latexmk_continuous = 0
let g:vimtex_latexmk_background = 0
let g:vimtex_latexmk_callback = 0

nmap <C-\> <plug>(vimtex-cmd-create)
imap <C-\> <plug>(vimtex-cmd-create)

let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'

let g:vimtex_complete_recursive_bib = 1
let g:vimtex_fold_enabled = 1
let g:vimtex_fold_preamble = 1
let g:vimtex_fold_comments = 1
let g:vimtex_indent_enabled = 1
let g:vimtex_indent_bib_enabled = 1
let g:vimtex_format_enabled = 1 " this did not work well, recheck if fixed

let g:vimtex_disable_version_warning = 1 " avoid checking manually latexmk, bibtex and stuff
" }}}
" Syntastic {{{
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_auto_jump                = 0
" dont clutter the loc list
let g:syntastic_always_populate_loc_list = 0
let g:loc_list_height                    = 5
let g:syntastic_aggregate_errors         = 1
let g:syntastic_id_checkers              = 1
let g:syntastic_auto_loc_list            = 0
let g:tsuquyomi_disable_quickfix         = 1
let g:syntastic_typescript_checkers      = ['tsuquyomi'] " You shouldn't use 'tsc' checker.
" tex checker
let g:syntastic_tex_checkers             = ["chktex", "lacheck"]
" 1: Cmd terminated with space
" 8: Wrong type of dashes
" 36: spaces around braces
let g:syntastic_tex_chktex_args          = "-n1 -n8 -n36"
" python checker
let g:syntastic_python_checkers          = ['python', 'flake8']
" let g:syntastic_python_checkers          = []
let g:syntastic_python_python_exec       = '/usr/bin/python3'
" let g:syntastic_python_flake8_exec       = '/usr/bin/python3'
" E402 : module level import not at top of file
" E501, E203
let g:syntastic_python_flake8_args       = '--ignore=E402'
" let g:syntastic_python_flake8_args       = '-m flake8'


nnoremap <leader>e :Errors<CR>
" }}}
" indentline {{{
let g:indentLine_setColors = 0 
let g:indentLine_setConceal = 0
" }}}
" delimitmate {{{
let delimitMate_expand_cr = 1
" }}}
" jedi  {{{ "
let g:jedi#popup_on_dot         = 0
let g:jedi#smart_auto_mappings  = 0
let g:jedi#show_call_signatures = 1
let g:jedi#force_py_version     = s:python_version
" }}} jedi  "
" simpyl-fold {{{
let g:SimpylFold_docstring_preview = 1
" }}}
" pandoc {{{
let g:pandoc#formatting#mode = 's'
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#filetypes#handled         = ["extra", "pandoc", "rst", "textile"]
let g:pandoc#modules#disabled          = ["menu"]
let g:pandoc#syntax#conceal#urls       = 1
let g:pandoc#completion#bib#mode       = 'citeproc'
" let g:pandoc#biblio#bibs               = ["~/git/vec4ir/masters/masters.bib"]
" }}}
" table mode (pandoc table compatible) {{{
" let g:table_mode_corner                = '+'
" let g:table_mode_seperator             = '|'
" let g:table_mode_fillchar              = '-'
" nmap <leader>,tr :TablemodeRealign<cr>
" }}}
" Ack {{{ "
nnoremap <leader>a :Ack!<space>
" }}} Ack "
" Signify {{{
let g:signify_vcs_list = [ 'git' ]
let g:signify_line_highlight = 0
" }}}
" TagBar {{{
" }}}
" easy-align {{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
vmap <Enter> <Plug>(EasyAlign)
" }}}
" Goyo and Limelight {{{

let g:limelight_conceal_ctermfg = 240

function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  set scrolloff=999
  " packadd seoul256.vim
  " color seoul256-light
  Limelight
  " ...
  set nocursorcolumn nocursorline
  set background=light
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
  " ...
  set background=dark
  set cursorcolumn cursorline
endfunction

augroup GoLime
  au!
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

" }}}
" Angular and Typescript {{{
" whos using it
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
if has("autocmd")
  augroup qfpost
    au!
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
  augroup END
endif
" }}}
" }}}
" Section: The Packs {{{ "

" Provides :Man
runtime! ftplugin/man.vim
" default keyword prg, filetype specific may still be overwritten by autocmds
set keywordprg=:Man

if has('packages')
  packadd syntastic
  if has('syntax') && has('eval')
    packadd matchit
  endif
  " need to load vimtex as usual
else
  " BACKWARDS COMPATIBLE
  runtime pack/core/opt/vim-pathogen/autoload/pathogen.vim
  echom "Pathogen infection."
  execute pathogen#infect('pack/core/start/{}' , 'pack/extra/start/{}' , 'pack/community/start/{}' , 'pack/testing/start/{}')
  " execute pathogen#infect('pack/core/opt/{}'   , 'pack/extra/opt/{}'   , 'pack/community/opt/{}'   , 'pack/testing/opt/{}')
endif

" }}} the packs "

if !exists('$TMUX') && has('termguicolors')
  " this should only be used if outside tmux
  set termguicolors
endif

syntax on
set background=dark
silent! colo gruvbox

  if has("autocmd")
  " Must be placed after syntax on
  augroup rainbow_parents
    au!
    au VimEnter * RainbowParenthesesActivate
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
    " au Syntax * RainbowParenthesesLoadChevrons
  augroup END
endif
