" Compatibility and Dynamic Python {{{
set nocompatible
if has('python') " if dynamic py|py3 support is enabled, this line already activates python 3.
  let s:python_version = 2
elseif has('python3')
  let s:python_version = 3
else
  let s:python_version = 0
endif
" echomsg 'Using python'.s:python_version
" }}}
" Section: Basic Options {{{
set autowrite
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
if has("linebreak")
  " dont break in the middle of a word
  set linebreak
  " ident line breaks
  set breakindent
  let &showbreak = "+++ "
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
" typescript development
set wildignore+=*/.git/*
set wildignore+=*.js,*.map
set wildignore+=tags,.*.un~,*.pyc
set wildignore+=*.bbl,*.aux,*.lot,*.lof,*.bcf,*.soc,*.fdb_latexmk,*.out
set wildmode=longest:full,full


" vim8 specific
if v:version >= 800
  set signcolumn=yes
endif
" }}}
 " Section: Maps {{{
if has('conceal')
  set conceallevel=2 concealcursor=
endif

let mapleader = ","
let maplocalleader = "\\"

" movement
map <Tab> %
map Y y$
nnoremap H ^
nnoremap L $
" command line
noremap + :
noremap @+ @:
" modes
" Convenience
vnoremap <Space> I<Space><Esc>gv
nnoremap <Space> za
inoremap <C-C> <Esc>`^
nnoremap <C-S> :w<cr>
inoremap <C-X>^ <C-R>=substitute(&commentstring,' \=%s\>'," -*- ".&ft." -*- vim:set ft=".&ft." ".(&et?"et":"noet")." sw=".&sw." sts=".&sts.':','')<CR>

" Forward to next marker
inoremap <silent> <C-J> <Esc>/<++<CR>zvzzv/++>/e<CR><Esc>:nohlsearch<CR>gv<C-G>
snoremap <silent> <C-J> <Esc>/<++<CR>zvzzv/++>/e<CR><Esc>:nohlsearch<CR>gv<C-G>
" Going backward to next marker
" When in insert mode, markers have been replaced already
" When still in select mode, skip marker
inoremap <silent> <C-K> <Esc>1?<++<CR>zvzzv/++>/e<CR><Esc>:nohlsearch<CR>gv<C-G>
snoremap <silent> <C-K> <Esc>2?<++<CR>zvzzv/++>/e<CR><Esc>:nohlsearch<CR>gv<C-G>
inoremap <C-R><C-K> <C-K>

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
    autocmd FileType pandoc setlocal et sw=4 sts=4
    autocmd FileType dot let b:dispatch="dot -Tpdf -o %:r.pdf %"
    " guess the dispatch by shebang
    autocmd BufReadPost * if getline(1) =~# '^#!' | let b:dispatch = getline(1)[2:-1] . ' %' | let b:start = b:dispatch | endif
    autocmd FileType html setlocal foldmethod=marker foldmarker=<div,/div> iskeyword+=-
    if exists("+omnifunc")
      autocmd FileType * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    endif
    autocmd FileType tex syn sync minlines=100 maxlines=300
          \ | let b:surround_{char2nr('x')} = "\\texttt{\r}"
          \ | let b:surround_{char2nr('l')} = "\\\1identifier\1{\r}"
          \ | let b:surround_{char2nr('e')} = "\\begin{\1environment\1}\n\r\n\\end{\1\1}"
          \ | let b:surround_{char2nr('v')} = "\\verb|\r|"
          \ | let b:surround_{char2nr('V')} = "\\begin{verbatim}\n\r\n\\end{verbatim}"
    autocmd FileType tex,mail if exists(':Thesaurus') | setlocal keywordprg=:Thesaurus | endif
    autocmd FileType tex,mail,pandoc setlocal iskeyword+=@,-,#
    " autocmd FileType pandoc nnoremap <buffer> <Leader>eb 
  augroup END
endif
" }}}
" Section: Core {{{
" Markdown {{{
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
" }}}
" Flagship {{{
" this is hacky to fix with to 2
set statusline=%#SignColumn#%-2.2(%M\ %)%*
set statusline+=%#CursorLineNr#%4.4(%c%)%*
" buffer number and modified
set statusline+=[b%n\ %f%(\ *%{fugitive#head()}%)]
" file
" usual stuff
set statusline+=\ %H%R
set statusline+=%=
augroup veight_flagship
  au!
  " this is necessary because (vim-signify|vim-gitgutter) somehow breaks colors
  let hl_as_usual = {"hl": ['Statusline', 'StatusLineNC']}
  " autocmd User Flags call Hoist("buffer", -10, hl_as_usual, function('fugitive#statusline'))
  autocmd User Flags call Hoist("window", +10, {"hl": ['WarningMsg','StatusLineNC']}, 'SyntasticStatuslineFlag')
  autocmd User Flags call Hoist("window", -10, hl_as_usual, "%{tagbar#currenttag('[%s]', '')}")
  autocmd User Flags call Hoist("buffer", -10, hl_as_usual, "[%{&formatoptions}]")
  autocmd User Flags call Hoist("buffer", 0, hl_as_usual, '%{g:asyncrun_status}')
  autocmd User Flags call Hoist("global", 0, hl_as_usual, "[%{&cpoptions}]")
augroup END
" }}}
" Fugitive {{{
nmap <leader>gs :Gstatus<cr>
nmap <leader>gw :Gwrite<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gp :Gpush<cr>
nmap <leader>gf :Gfetch<cr>
nmap <leader>gm :Gmerge<cr>
" }}}
" Tabular {{{
nnoremap <leader>t= :Tabularize /=/<CR>
nnoremap <leader>t& :Tabularize /&/<CR>
nnoremap <leader>t# :Tabularize /#/<CR>
" }}}
" CtrlP {{{
let g:ctrlp_map = '<leader>,'
nnoremap <leader>. :CtrlPTag<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
let g:ctrlp_extensions = ['tag']
" }}}
" }}}
" Section: Extra {{{
" ack {{{
let g:ack_use_dispatch = 1
" }}}
" XPTemplate {{{
let g:xptemplate_vars="$author=Lukas\ Galke&$email=vim@lpag.de"
" }}}
" PyMode {{{
let g:pymode_python = 'python3'
let g:pymode_lint_unmodified = 1
let g:pymode_rope_complete_on_dot = 0 " leave this to completion engine
" }}}
" pep8 indent {{{
let g:python_pep8_indent_multiline_string = 1
" }}}
" Dispatch {{{
nnoremap <leader>m :Make<cr>
nnoremap <leader>d :Dispatch<cr>
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
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.
" invoke error loc list manually
nmap <silent> <leader>e :Errors<CR>
" tex checker
let g:syntastic_tex_checkers = ["chktex", "lacheck"]
" 1: Cmd terminated with space
" 8: Wrong type of dashes
" 36: spaces around braces
let g:syntastic_tex_chktex_args = "-n1 -n8 -n36"
" python checker
let g:syntastic_python_checkers = ['python', 'flake8']
let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:syntastic_python_flake8_exec = '/usr/bin/python3'
" E402 : module level import not at top of file
let g:syntastic_python_flake8_args = '-m flake8 --ignore=E501,E203,E402'

nnoremap <leader>e :Errors<CR>
" }}}
" UltiSnips {{{
let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips"
let g:UltiSnipsListSnippets = "<c-r><c-r><Tab>"
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
inoremap <c-x><c-k> <c-x><c-k>
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
" }}}
" Section: Community {{{
" dotoo
let g:dotoo#agenda#files = ['~/.plan/*.dotoo', '~/git/vec4ir/vec4ir.dotoo']
" pandoc
" let g:pandoc#formatting#mode = 'ha'
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#filetypes#handled         = ["extra", "pandoc", "rst", "textile"]
let g:pandoc#modules#disabled          = ["menu"]
let g:pandoc#syntax#conceal#urls       = 1
let g:pandoc#completion#bib#mode       = 'citeproc'
" let g:pandoc#biblio#bibs               = ["~/git/vec4ir/masters/masters.bib"]
" table mode (pandoc table compatible) {{{
let g:table_mode_corner                = '+'
let g:table_mode_seperator             = '|'
let g:table_mode_fillchar              = '-'
nmap <leader>,tr :TablemodeRealign<cr>
" }}}
" }}}
" Section: Testing {{{
" Async {{{ "
nnoremap <leader>a :Ack!<space>
nnoremap & :AsyncRun<space>
" }}} Async "
" Signify {{{
let g:signify_vcs_list = [ 'git' ]
let g:signify_line_highlight = 0
" }}}
" TagBar {{{
nmap <F2> :TagbarToggle<CR>
" }}}
" VimCompletesMe + vimtex {{{
augroup VimCompletesMeTex
  autocmd!
  autocmd FileType tex let b:vcm_omni_pattern =
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
augroup END
" }}}
" Completor {{{
let g:completor_python_binary = '/usr/bin/env python3'
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
  " if v:version > 703 && s:python_version
  "   packadd python-mode
  " endif
  " if has("lua") && v:version > 738
  "   packadd neocomplete.vim
  "   packadd neosnippet.vim
  "   packadd neosnippet-snippets
  "   packadd neco-vim
      " neosnippet {{{
      " let g:neosnippet#enable_snipmate_compatibility = 1
      " imap <C-k>     <Plug>(neosnippet_expand_or_jump)
      " smap <C-k>     <Plug>(neosnippet_expand_or_jump)
      " xmap <C-k>     <Plug>(neosnippet_expand_target)
      " }}}
  " else
  if s:python_version
    packadd vim-snippets
    packadd ultisnips
  endif
  if s:python_version && has('job') && has('timers') && has('lambda')
    packadd completor.vim
  else
    packadd VimCompletesMe
  endif
  " endif
  if s:python_version == 2
    packadd jedi-vim
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
  augroup rainbow
    au!
    au VimEnter * RainbowParenthesesActivate
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
    au Syntax * RainbowParenthesesLoadChevrons
  augroup END
endif
