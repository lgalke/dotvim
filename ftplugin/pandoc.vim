function! Heading(level) abort
  let cline = line('.')
  silent! .,.:s/\m^#\+\s*//
  silent! .,.+1:s/\m\n=\+$\|\n-\+$//
  call cursor(cline, 0)
  if a:level == 1
    normal yypVr=
  elseif a:level == 2
    normal yypVr-
  else
    execute "normal 0i" . repeat('#', a:level) . " "
  endif
  call cursor(cline, 0)
endfunction

nnoremap <localleader>h1 :call <SID>Heading(1)<CR>
nnoremap <localleader>h2 :call <SID>Heading(2)<CR>
nnoremap <localleader>h3 :call <SID>Heading(3)<CR>
nnoremap <localleader>h4 :call <SID>Heading(4)<CR>
nnoremap <localleader>h5 :call <SID>Heading(5)<CR>
nnoremap <localleader>h6 :call <SID>Heading(6)<CR>
