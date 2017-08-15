function! Heading(level) abort
  let l:cline = line('.')
  silent! .,.:s/\m^#\+\s*//
  silent! .,.+1:s/\m\n=\+$\|\n-\+$//
  call cursor(l:cline, 0)
  if a:level == 1
    normal! yypVr=
  elseif a:level == 2
    normal! yypVr-
  else
    execute 'normal 0i' . repeat('#', a:level) . ' '
  endif
  call cursor(l:cline, 0)
endfunction

nnoremap <buffer> <localleader>h1 :call <SID>Heading(1)<CR>
nnoremap <buffer> <localleader>h2 :call <SID>Heading(2)<CR>
nnoremap <buffer> <localleader>h3 :call <SID>Heading(3)<CR>
nnoremap <buffer> <localleader>h4 :call <SID>Heading(4)<CR>
nnoremap <buffer> <localleader>h5 :call <SID>Heading(5)<CR>
nnoremap <buffer> <localleader>h6 :call <SID>Heading(6)<CR>

" next link
nnoremap <buffer> <C-N> /\[[^\]]\+\](\zs[^)]\+)<CR>
" previous link
nnoremap <buffer> <C-P> ?\[[^\]]\+\](\zs[^)]\+)<CR>

function! s:Section_motion(backward, exclusive)
  call search('^#\+', a:backward ? 'b' : '')
  if a:exclusive
    if a:backward
      normal! j
    else
      normal! k
    endif
  endif
endfunction

noremap ]] :<C-U>call <SID>Section_motion(0,0)<CR>
noremap ][ :<C-U>call <SID>Section_motion(0,1)<CR>
noremap [[ :<C-U>call <SID>Section_motion(1,0)<CR>
noremap [] :<C-U>call <SID>Section_motion(1,1)<CR>

function! s:Header_object(inner)
  call s:Section_motion(1, a:inner)
  normal! V
  call s:Section_motion(0, 1)
endfunction

onoremap ah :<C-U>call <SID>Header_object(0)<CR>
onoremap ih :<C-U>call <SID>Header_object(1)<CR>
xnoremap ah :<C-U>call <SID>Header_object(0)<CR>
xnoremap ih :<C-U>call <SID>Header_object(1)<CR>
