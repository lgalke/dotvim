iabbrev <buffer> if if:<Left>
iabbrev <buffer> while while:<Left>
" generator
iabbrev <buffer> for) (for<Space>in<Space>)<Left><Left><Left><Left><Left>
" list comprehension
iabbrev <buffer> for] [for<Space>in<Space>]<Left><Left><Left><Left><Left>
" dict comprehension
iabbrev <buffer> for} {for<Space>in<Space>}<Left><Left><Left><Left><Left>


nnoremap <buffer> <localleader>psh yiwoprint()<Esc>Pa.shape<Esc>
nnoremap <buffer> <localleader>pvsh yiwoprint()<Esc>Pa.shape<Esc>vT(yPa",<Space><Esc>F(a"<Esc>


