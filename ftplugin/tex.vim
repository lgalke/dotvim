xnoremap <buffer> <Localleader>dmb :s/\\mathbf{\([^}]*\)}/\1/g<CR>
nnoremap <buffer> <Localleader>dmb :s/\\mathbf{\([^}]*\)}/\1/g<CR>

command! -buffer -bang -range -nargs=1 -complete=file Export <line1>,<line2>w! >> <args>
      \| if '<bang>' == '!'
        \| <line1>,<line2>d 
        \| call append(line('.') - 1, '\input{<args>}')
      \| endif
