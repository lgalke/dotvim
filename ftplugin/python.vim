iabbrev <buffer> while while:<Left>
" generator
iabbrev <buffer> for) (for<Space>in<Space>)<Left><Left><Left><Left><Left>
" list comprehension
iabbrev <buffer> for] [for<Space>in<Space>]<Left><Left><Left><Left><Left>
" dict comprehension
iabbrev <buffer> for} {for<Space>in<Space>}<Left><Left><Left><Left><Left>


nnoremap <buffer> <localleader>psh yiwoprint()<Esc>Pa.shape<Esc>
nnoremap <buffer> <localleader>pvsh yiwoprint()<Esc>Pa.shape<Esc>vT(yPa",<Space><Esc>F(a"<Esc>
nnoremap <buffer> <localleader>flatten yiwo[item<Space>for<Space>sublist<Space>in<Space><Esc>pA<Space>for<Space>item<Space>in<Space>sublist]<Esc>^i

let b:switch_custom_definitions = [ ['ReLU', 'SELU'], ['Sigmoid', 'Tanh'], ['Dropout', 'AlphaDropout' ] ]


