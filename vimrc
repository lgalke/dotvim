" Preamble: Compatibility and Dynamic Python {{{
scriptencoding
" set nocompatible
" Store currently active python version for rest of script
" echomsg 'Using python'.s:python_version
" }}}
" Section: Basic Options {{{
" Behavior {{{
set autowrite
set ignorecase smartcase
set foldopen+=jump
set backspace=2
if has('persistent_undo')
  set undofile	" keep an undo file (undo changes after closing)
endif
" }}}
" Interface and Behaviour{{{
" Searching and matching braces
set hlsearch incsearch

" They bug around with jedi
set noshowmatch

" Show current command ruler
set showcmd ruler

" Always show status and tabline
set laststatus=2 showtabline=2
" But no cursor column nor line
" And not all the numbers.
set number relativenumber
set cursorline cursorcolumn

set scrolloff=5

set guioptions-=e "recommended by flagship
set splitright
set confirm
" vim8 specific
if v:version >= 800
  set signcolumn=auto
endif
if has('conceal')
  set conceallevel=2 concealcursor=
endif
" }}}
" Indent and Tabs{{{
set expandtab
set shiftround
set autoindent
set smartindent
" }}}
" Lists {{{
set list
set listchars=eol:¶,tab:¦-,trail:·,extends:»,precedes:«,nbsp:~
" }}}
" Wraps and Breaks {{{
set wrap
if has('linebreak')
  " dont break in the middle of a word
  set linebreak
  " indent line breaks
  if exists('+breakindent')
    set breakindent showbreak=\ +
  endif
endif

if has('suffixesadd')
  set suffixesadd=.tex
endif
" }}}
" Defaults (may be changed on ft) {{{
set foldmethod=marker
set commentstring=#\ %s
set formatoptions=rqn1j
" Provides :Man
runtime! ftplugin/man.vim
set keywordprg=:Man
" }}}
" Completion {{{
set dictionary+=/usr/share/dict/words
set complete-=i
set complete-=d
set completeopt+=longest
set spelllang=en_us
" }}}
" Going Wild {{{
set wildmenu
set wildignore+=tags,.*.un~,*.pyc
" Never ever descend into these directories
set wildignore+=node_modules
set wildignore+=*/.git/*
" alot of temporary latex files...
set wildignore+=*.bbl,*.aux,*.lot,*.lof,*.bcf,*.soc,*.fdb_latexmk,*.out,*.run.xml,*.blg,*.fls,*.log,*.toc
set wildmode=longest:full,full
set wildcharm=<C-z>
" }}}
" Proper Line Return {{{
augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END
" }}}
" Native global options {{{
let g:tex_flavor = 'latex'
let g:is_bash = 1
let g:python_highlight_all = 1
set completefunc=autoprogramming#complete
" }}}
" File Movement {{{
set path+=**
" }}}
" }}}
" Section: Statusline {{{
" this is hacky to fix with to 2
" set statusline=%#WarningMsg#%-2.2(%M\ %)%*
" set statusline+=%#CursorLineNr#%4.4(%c%)%*
" " buffer number and modified
" set statusline+=[b%n\ %f%(\ *%{fugitive#head()}%)]
" " file
" " usual stuff
" set statusline+=\ %H%R
" set statusline+=%=
" set statusline+=%a
" set statusline+=\ @\ %P
let s:hl_as_usual = {'hl': 'Statusline'}
augroup my_flagship
  au!
  autocmd User Flags call Hoist('buffer', +10, {'hl': 'WarningMsg'}, 'SyntasticStatuslineFlag')
  autocmd User Flags call Hoist('buffer', +10, {'hl': 'WarningMsg'}, 'ALEGetStatusLine')
  autocmd User Flags call Hoist('window', +10, s:hl_as_usual, "%{tagbar#currenttag('[%s]', '')}")
  autocmd User Flags call Hoist('buffer', -10, s:hl_as_usual, '[%{&formatoptions}]')
  autocmd User Flags call Hoist('buffer', -10, s:hl_as_usual, '[%{&complete}]')
  " autocmd User Flags call Hoist("buffer", 0, hl_as_usual, '%{g:asyncrun_status}')
  autocmd User Flags call Hoist('global', 0, "[%{&cpoptions}]")
  " this is necessary because (vim-signify|vim-gitgutter) somehow breaks colors
  " autocmd User Flags call Hoist("buffer", -10, hl_as_usual, function('fugitive#statusline'))
augroup END
" }}}
" Section: The Map {{{
let g:mapleader = ' '
let g:maplocalleader = '\'
inoremap <C-C> <Esc>`^
" map <Tab> %
noremap Y y$
noremap H ^
noremap L $



" set winwidth=80

" Convenience
nnoremap <C-S> :w<cr>
" i dont need multiple cursors
xnoremap <C-S> :s/
" zvzz
" nnoremap n nzvzz
" nnoremap N Nzvzz

" Visual adjustments
xmap < <gv
xmap > >gv

" No accidents with the mousepad
nmap <Up> <nop>
nmap <Down> <nop>
nmap <Left> <nop>
nmap <Right> <nop>

" quick spell correction
nnoremap <C-X><C-S> ea<C-X><C-S>
inoremap <C-K><C-K> <Esc>:help digraph-table<CR>


" quick modeline, thanks to the pope
inoremap <C-X>^ <C-R>=substitute(&commentstring,' \=%s\>'," -*- ".&ft." -*- vim:set ft=".&ft." ".(&et?"et":"noet")." sw=".&sw." sts=".&sts.':','')<CR>

" F keys {{{
nmap    <F2>     :20Lex<CR>
" we could merge f3 and f4

if has('autocmd')
  augroup f4_map
    au!
    au    User     VimtexEventInitPost nmap <buffer> <F4> <plug>(vimtex-toc-toggle)
    au    FileType pandoc              if exists(':TOC') | nmap <buffer> <F4> :TOC<CR> | endif
  augroup END
endif

nmap <F5> :if exists(':MundoToggle')<Bar>exe 'MundoToggle'<Bar>endif<CR>

" Tpope's fkeys are cool
nmap    <F6>  :if &previewwindow<Bar>pclose<Bar>elseif exists(':Gstatus')<Bar>exe 'Gstatus'<Bar>else<Bar>ls<Bar>endif<CR>
nmap    <F7>  :if exists(':Lcd')<Bar>exe 'Lcd'<Bar>elseif exists(':Cd')<Bar>exe 'Cd'<Bar>else<Bar>lcd %:h<Bar>endif<CR>
map     <F8>  :Make<CR>
map     <F9>  :Dispatch<CR>
map     <F10> :Start<CR>
" }}}

" Title case

" Quick access
nnoremap <leader>v :edit $MYVIMRC<cr>
nnoremap <Leader>f :find<Space>
nnoremap <Leader>b :ls<CR>:b<Space>
nnoremap <leader>t :TagbarToggle<CR>
"}}}
" Section: Text Objects {{{
" Pipe tables
" Complements cucumbertables.vim by tpope
" inoremap <Bar>-<Bar> <Esc>kyyp:s/\v[^<Bar>]/-/g<CR>:nohlsearch<CR>j

" test object for table cells
onoremap i<Bar> :<c-u>normal! T<Bar>vt<Bar><cr>
onoremap a<Bar> :<c-u>normal! F<Bar>vf<Bar><cr>
" }}} Section: Text Objects
" Section: Abbreviations and Graveyard {{{ 
if exists('*strftime')
  iabbrev :date: <c-r>=strftime("%d/%m/%y")<cr>
  iabbrev :time: <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
endif
" The following is one mapping for all: 
" - Visual selection: :w \g/<filename> will create a grave
" - Reanimating skeletons by :r \g/<filename>
" - Editing a skeleton... :e \g/filename
cabbrev \g $HOME/.vim/graveyard
iabbrev +++ <++++><Left><Left><Left>
" After searching for the rune markers, you can replace as follows:
" navigate through them vi n/N as usual,
nnoremap <leader>m /<++[^\%(++>\)]\{-}++>/<CR>
let g:surround_{char2nr('m')} = "<++\r++>"
" ok i should not write that says proselint
iabbrev very damn
"}}}
" Section: Autocmds {{{

if has('autocmd')
  filetype plugin indent on
  augroup vimrc_ex

    au!
    autocmd FileType    help             setlocal keywordprg=:help
    " q enough
    autocmd FileType    qf,help,netrw          nnoremap <buffer> q :q!<CR>
    " as recommended to not write ugly mails for others
    autocmd FileType    mail             setlocal formatoptions+=aw
    " make useful dispatch
    autocmd FileType    pandoc           if exists(':Pandoc') | let b:dispatch=":Pandoc pdf" | endif                                    
    autocmd FileType    pandoc,markdown  setlocal et sw=4 sts=2 iskeyword+=@,-,#
    autocmd FileType    dot              let b:dispatch="dot -Tpdf -o %:r.pdf %"  | setlocal commentstring=//%s
    " guess the dispatch by shebang
    autocmd BufReadPost *                if getline(1) =~# '^#!' | let b:dispatch = getline(1)[2:-1] . ' %' | let b:start = b:dispatch | endif
    autocmd FileType    perl,python,ruby inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&ft<CR>
    autocmd FileType    html             setlocal foldmethod=marker foldmarker=<div,/div> iskeyword+=-
    autocmd FileType tex                 syn sync minlines=100 maxlines=300
          \ |        let                 b:surround_{char2nr('x')} = "\\texttt{\r}"
          \ |        let                 b:surround_{char2nr('c')} = "\\\1identifier\1{\r}"
          \ |        let                 b:surround_{char2nr('e')} = "\\begin{\1environment\1}\n\r\n\\end{\1\1}"
          \ |        let                 b:surround_{char2nr('v')} = "\\verb|\r|"
          \ |        let                 b:surround_{char2nr('V')} = "\\begin{verbatim}\n\r\n\\end{verbatim}"
    autocmd FileType    txt,tex,mail,pandoc,markdown  if exists(':Thesaurus') | setlocal keywordprg=:Thesaurus | endif 
          \ | setlocal spell
    autocmd FileType    python           setlocal textwidth=79 colorcolumn=+1 softtabstop=4 shiftwidth=4 expandtab
    autocmd FileType    python           nnoremap <leader>c 0f(3wyt)o<ESC>pV:s/\([a-z_]\+\),\?/self.\1 = \1<C-v><CR>/g<CR>ddV?def<CR>j
    autocmd FileType    python           setlocal omnifunc=jedi#completions
    autocmd FileType    *                if       exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    " autocmd CursorHold  *                smile
    autocmd FileType vim                 setlocal formatoptions-=o
    " expands plain node to explicitly labelled node.
    autocmd FileType dot                 nnoremap <buffer> <localleader>el viwyA<Space>[label=""]<Esc>F"P$
    autocmd FileType html,typescript     execute angular_cli#init()
    " autocmd VimEnter * if glob("node_modules/@angular") != '' | execute angular_cli#init() | endif
  augroup END

endif
let g:angular_cli_debug = 1

" }}}
" Section: Plugins {{{
" Small adjustments {{{

let g:markdown_fenced_languages           = ['html', 'python', 'bash=sh']

let g:SimpylFold_docstring_preview        = 1

let g:python_pep8_indent_multiline_string = 1
let g:ragtag_global_maps                  = 1
let g:online_thesaurus_map_keys           = 0

" Reinclude angular cli?
let g:angular_cli_use_dispatch            = 1

" }}}
" Vimtex {{{
augroup vimtex_customization
  au!
  au User VimtexEventInitPost 
        \ call vimtex#imaps#add_map({'lhs' : 'bs', 'rhs' : '\boldsymbol{}<Left>'}) |
        \ call vimtex#imaps#add_map({'lhs' : 'bb', 'rhs' : '\mathbb{}<Left>'})
augroup END

let g:vimtex_compiler_latexmk = {
      \ 'backend' : 'jobs',
      \ 'background' : 1,
      \ 'build_dir' : '',
      \ 'callback' : 0,
      \ 'continuous' : 1,
      \ 'options' : [
      \   '-pdf',
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}
let g:vimtex_view_general_viewer          = 'okular'
let g:vimtex_view_general_options         = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
let g:vimtex_complete_recursive_bib       = 1
let g:vimtex_fold_enabled                 = 1
let g:vimtex_fold_preamble                = 1
let g:vimtex_fold_comments                = 1
let g:vimtex_indent_enabled               = 1
let g:vimtex_indent_bib_enabled           = 1
let g:vimtex_format_enabled               = 1 " this did not work well, recheck if fixed
let g:vimtex_disable_version_warning      = 1 " avoid checking manually latexmk, bibtex and stuff
" }}}
" Syntastic {{{
let g:syntastic_check_on_open             = 1
let g:syntastic_check_on_wq               = 0
let g:syntastic_auto_jump                 = 0
" dont clutter the loc list
let g:syntastic_always_populate_loc_list  = 1
let g:loc_list_height                     = 5
let g:syntastic_aggregate_errors          = 1
let g:syntastic_id_checkers               = 1
let g:syntastic_auto_loc_list             = 0
let g:tsuquyomi_disable_quickfix          = 1
let g:syntastic_typescript_checkers       = ['tsuquyomi'] " You shouldn't use 'tsc' checker.
" tex checker
let g:syntastic_tex_checkers              = ['chktex', 'lacheck', 'proselint']
" 1: Cmd terminated with space
" 8: Wrong type of dashes
" 36: spaces around braces
let g:syntastic_tex_chktex_args           = '-n1 -n8 -n36'
" Html
" let g:syntastic_html_checkers             = 
" python checker
let g:syntastic_python_checkers           = ['python', 'flake8']
" let g:syntastic_python_checkers          = []
let g:syntastic_python_python_exec        = '/usr/bin/python3'
" let g:syntastic_python_flake8_exec       = '/usr/bin/python3'
" E402 : module level import not at top of file
" E501, E203
let g:syntastic_python_flake8_args        = '--ignore=E402'
" let g:syntastic_python_flake8_args       = '-m flake8'

" Fill quickfix list
" }}}
" Easy-Align {{{
" Unused
" Start interactive EasyAlign in visual mode (e.g. vipga)
" xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
" nmap ga <Plug>(EasyAlign)
" }}}
" Sideways {{{
nnoremap <a :SidewaysLeft<cr>
nnoremap >a :SidewaysRight<cr>
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI
" }}}
" ALE {{{
let g:ale_echo_msg_error_str   = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format      = '[%linter%] %s [%severity%]'

" python
let g:ale_python_mypy_options = '--ignore-missing-imports'
" Module import not at start of file
let g:ale_python_flake8_args = '--ignore=E402'

" tex
" We drop default -I
" n1 command terminated with space
" n8 wrong length of dash, I KNOW IT
let g:ale_tex_chktex_options = '-n1'

let g:ale_linter_aliases = {'pandoc': 'markdown'}
" }}}
" jedi  {{{ "
" showmode needs to be disabled to show call signatures in modeline
set noshowmode
let g:jedi#popup_on_dot         = 0
let g:jedi#smart_auto_mappings  = 0
let g:jedi#show_call_signatures = 2
" let g:jedi#force_py_version     = &pyx
" }}} jedi  "
" pandoc {{{
let g:pandoc#formatting#mode           = 's'
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#filetypes#handled         = ['extra', 'pandoc', 'rst', 'textile']
let g:pandoc#modules#disabled          = ['menu']
let g:pandoc#syntax#conceal#urls       = 1
let g:pandoc#completion#bib#mode       = 'citeproc'
let g:pandoc#keyboard#display_motions  = 0
" }}}
" Angular and Typescript {{{
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
" }}}
" {{{ Github Dashboard
let g:github_dashboard = {}
let g:github_dashboard['emoji'] = 1
let g:github_dashboard['emoji_map'] = {
      \   'user_dashboard': 'blush',
      \   'user_activity':  'smile',
      \   'repo_activity':  'laughing',
      \   'ForkEvent':      'fork_and_knife'
      \ }
" }}}
" {{{
let g:fugitive_gitlab_domains = [ 'https://git.kd.informatik.uni-kiel.de' ]
" }}}
" }}}
" Section: The Packs {{{ "
if has('packages')
  if has('timers') && exists('*job_start') && exists('*ch_close_in')
    " packadd! ale
  else
    packadd! syntastic
    nnoremap <leader>e :Errors<CR>
  endif
  command! -bar -bang -complete=packadd -nargs=1 Packadd packadd<bang> <args> | doautoall BufRead
  command! -bar -nargs=0 Helptags silent! helptags ALL
  if has('syntax') && has('eval')
    packadd! matchit
    " Remember b:match_words
    " and help topic matchit-newlang
  endif
else
  " BACKWARDS COMPATIBLE
  runtime pack/tpope-pack/opt/vim-pathogen/autoload/pathogen.vim
  echom 'Pathogen infection.'
  execute pathogen#infect('pack/core/start/{}' , 'pack/extra/start/{}' , 'pack/community/start/{}' , 'pack/testing/start/{}')
  " execute pathogen#infect('pack/core/opt/{}'   , 'pack/extra/opt/{}'   , 'pack/community/opt/{}'   , 'pack/testing/opt/{}')
endif
" }}} The Packs "
" Section: Colors {{{
syntax enable
if has('termguicolors')
  " this should only be used if outside tmux
  set termguicolors
endif
set bg=dark
silent! colo gruvbox
" }}}
