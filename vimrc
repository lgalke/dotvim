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
set noshowmode
set foldmethod=marker
set showtabline=2
set guioptions-=e "recommended by flagship
set ignorecase
set smartcase
set shiftround
set showcmd
set showmatch
set autoindent
set smartindent
set wrap
set cursorline cursorcolumn
set foldopen+=jump
set display=lastline "give it a try
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
" %=%-14.(%l,%c%V%)\ %P
if has('persistent_undo')
  set undofile	" keep an undo file (undo changes after closing)
endif
let g:tex_flavor = 'latex'

" wild menu
set wildignore+=*/.git/*
set wildignore+=*.js,*.map
set wildignore+=tags,.*.un~,*.pyc
set wildignore+=*.bbl,*.aux,*.lot,*.lof,*.bcf,*.soc,*.fdb_latexmk,*.out
set wildmode=longest:full,full

augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END


" more complex options
set completeopt+=menuone,noinsert,noselect
let g:mucomplete#enable_auto_at_startup = 1
" see :help fo-table
set formatoptions=rqn1j


" vim8 specific
if v:version >= 800
  set signcolumn=yes
endif
" }}}
" statusline {{{
" this is hacky to fix with to 2
set statusline=%#SignColumn#%-2.2(%M\ %)%*
set statusline+=%#CursorLineNr#%4.4(%c%)%*
" buffer number and modified
set statusline+=[b%n\ %f%(\ *%{fugitive#head()}%)]
" file
" usual stuff
set statusline+=\ %H%R
set statusline+=%=
set statusline+=%a
set statusline+=%P
" }}}
 " Section: Maps {{{
if has('conceal')
  set conceallevel=2 concealcursor=
endif

let mapleader = ","
let maplocalleader = "\\"

" zvzz
nnoremap n nzvzz
nnoremap N Nzvzz

" movement
map <Tab> %
map Y y$
nnoremap H ^
nnoremap L $
" command line
noremap + :
noremap @+ @:
" modes
nmap <Up> <nop>
nmap <Down> <nop>
nmap <Left> <nop>
nmap <Right> <nop>
" Convenience
xnoremap <Space> I<Space><Esc>gv
nnoremap <Space> za
inoremap <C-C> <Esc>`^
nnoremap <C-S> :w<cr>

" thanks at the pope
inoremap <C-X>^ <C-R>=substitute(&commentstring,' \=%s\>'," -*- ".&ft." -*- vim:set ft=".&ft." ".(&et?"et":"noet")." sw=".&sw." sts=".&sts.':','')<CR>


" i dont need multiple cursors
xnoremap <C-S> :s/

" Literal marker movement
inoremap <silent> <C-F> <Esc>/\m<++.\{-}++>/<CR>zvzzgn<C-G>
inoremap <silent> <C-B> <Esc>?\m<++.\{-}++>?<CR>zvzzgn<C-G>
snoremap <silent> <C-F> <Esc>/\m<++.\{-}++>/<CR>zvzzgn<C-G>
snoremap <silent> <C-B> <Esc>2?\m<++.\{-}++>?<CR>zvzzgn<C-G>
iabbrev +++ <++ ++><Left><Left><Left><Left>
let g:surround_{char2nr('m')} = "<++\r++>"

" Tpope's fkeys make sense
nmap <silent> <F6> :if &previewwindow<Bar>pclose<Bar>elseif exists(':Gstatus')<Bar>exe 'Gstatus'<Bar>else<Bar>ls<Bar>endif<CR>
nmap <silent> <F7> :if exists(':Lcd')<Bar>exe 'Lcd'<Bar>elseif exists(':Cd')<Bar>exe 'Cd'<Bar>else<Bar>lcd %:h<Bar>endif<CR>
map <F8>    :Make<CR>
map <F9>    :Dispatch<CR>
map <F10>   :Start<CR>

" Title case
nnoremap <Leader>tc :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR>:nohlsearch<CR>


"Quick access
nnoremap <leader>vv :Vedit vimrc<cr>
nnoremap <leader>vx :edit ~/.vim/ftplugin<cr>
"}}}
" Section: Commands {{{
" command! -complete=packadd -nargs=1 Packadd packadd <args> | write | edit %
command! -bar -bang -complete=packadd -nargs=1 Packadd packadd<bang> <args> | doautoall BufRead
command! -bar -nargs=0 Helptags silent! helptags ALL

function! s:Tags() abort
  silent let dir = system("git rev-parse --show-toplevel")
  if v:shell_error
    let tagsfile = "./tags"
  else
    let tagsfile = dir . "/.git/tags"
  endif
  let cmd = ['ctags', '-R', '-f', tagsfile]
  let job = job_start(cmd)
endfunction

command! -bar -nargs=0 Tags call <SID>Tags()
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
    autocmd FileType pandoc if exists(':TOC') | nmap <F3> :TOC<CR> | endif
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
          \ | let b:surround_{char2nr('l')} = "\\\1identifier\1{\r}"
          \ | let b:surround_{char2nr('e')} = "\\begin{\1environment\1}\n\r\n\\end{\1\1}"
          \ | let b:surround_{char2nr('v')} = "\\verb|\r|"
          \ | let b:surround_{char2nr('V')} = "\\begin{verbatim}\n\r\n\\end{verbatim}"
    autocmd FileType tex,mail,pandoc if exists(':Thesaurus') | setlocal keywordprg=:Thesaurus | endif
    " autocmd FileType pandoc nnoremap <buffer> <Leader>eb 
    autocmd FileType python setlocal textwidth=79 colorcolumn=+1 softtabstop=4 shiftwidth=4 expandtab
    let hl_as_usual = {"hl": ['Statusline', 'StatusLineNC']}
    autocmd User Flags call Hoist("window", +10, {"hl": ['WarningMsg','StatusLineNC']}, 'SyntasticStatuslineFlag')
    autocmd User Flags call Hoist("window", -10, hl_as_usual, "%{tagbar#currenttag('[%s]', '')}")
    autocmd User Flags call Hoist("buffer", -10, hl_as_usual, "[%{&formatoptions}]")
    " autocmd User Flags call Hoist("buffer", 0, hl_as_usual, '%{g:asyncrun_status}')
    autocmd User Flags call Hoist("global", 0, hl_as_usual, "[%{&cpoptions}]")
    " this is necessary because (vim-signify|vim-gitgutter) somehow breaks colors
    " autocmd User Flags call Hoist("buffer", -10, hl_as_usual, function('fugitive#statusline'))
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
let g:vimtex_latexmk_background = 1
let g:vimtex_latexmk_callback = 0

" let g:vimtex_imaps_leader = '`'

let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'

let g:vimtex_fold_enabled = 1
let g:vimtex_fold_preamble = 1
let g:vimtex_fold_comments = 1
let g:vimtex_indent_enabled = 1
let g:vimtex_indent_bib_enabled = 1
let g:vimtex_format_enabled = 1 " this did not work well, recheck if fixed

let g:vimtex_disable_version_warning = 1 " avoid checking manually latexmk, bibtex and stuff
augroup vimtex_mappings
  au!
  au User VimtexEventInitPost nmap <F3> <plug>(vimtex-toc-toggle)
augroup END
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
let g:syntastic_python_checkers          = ['flake8']
" let g:syntastic_python_checkers          = []
let g:syntastic_python_python_exec       = '/usr/bin/python3'
" let g:syntastic_python_flake8_exec       = '/usr/bin/python3'
" E402 : module level import not at top of file
" let g:syntastic_python_flake8_args       = '-m flake8 --ignore=E501,E203,E402'
" let g:syntastic_python_flake8_args       = '-m flake8'


nnoremap <leader>e :Errors<CR>
" }}}
" UltiSnips {{{
let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips"
let g:UltiSnipsListSnippets = "<c-r><c-r><Tab>"
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-f>"
let g:UltiSnipsJumpBackwardTrigger = "<c-b>"
" }}}
" neocomplete {{{
" let g:neocomplete#enable_at_startup = 1
" let g:neocomplete#enable_smart_case = 1
" inoremap <expr><Tab>  neocomplete#start_manual_complete()
" inoremap <expr><C-g>     neocomplete#undo_completion()
" inoremap <expr><C-l>     neocomplete#complete_common_string()
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.tex =
      \ '\v\\%('
      \ . '\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
      \ . '|hyperref\s*\[[^]]*'
      \ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|%(include%(only)?|input)\s*\{[^}]*'
      \ . '|\a*(gls|Gls|GLS)(pl)?\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|includepdf%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . ')'
" let g:neocomplete#sources#omni#input_patterns.python =
"       \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
" }}}
" indentline {{{
let g:indentLine_setColors = 0 
let g:indentLine_setConceal = 0
" }}}
" jedi  {{{ "
let g:jedi#popup_on_dot = 1
let g:jedi#show_call_signatures = 2
" }}} jedi  "
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
nmap <F2> :TagbarToggle<CR>
" }}}
" easy-align {{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
vmap <Enter> <Plug>(EasyAlign)
" }}}
" Angular and Typescript {{{
" whos using it
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
" }}}
" }}}
" Section: The Packs {{{ "

" Provides :Man
runtime! ftplugin/man.vim
" default keyword prg, filetype specific may still be overwritten by autocmds
set keywordprg=:Man

if has('packages')
  packadd syntastic
  " chose snippet engine and completor
  if s:python_version
    packadd vim-snippets
    packadd ultisnips
    packadd jedi-vim
    augroup jedi_omnifunc
      au!
      au FileType python setlocal omnifunc=jedi#completions
    augroup END
  endif
  if has('syntax') && has('eval')
    packadd matchit
  endif
  " need to load vimtex as usual
  packadd vim-pathogen
  execute pathogen#infect('bundle/{}')
else
  " BACKWARDS COMPATIBLE
  runtime pack/core/opt/vim-pathogen/autoload/pathogen.vim
  echom "no +packages. compat mode by infecting with pathogen"
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
    au Syntax * RainbowParenthesesLoadChevrons
  augroup END
  augroup custom_syntax
    autocmd Syntax python syn match Error /\s\+$/
  augroup END
endif
