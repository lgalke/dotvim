" I always forget it in method names, so highlight to remember
syn keyword pythonBuiltinObj     self
" Common package abbreviations
syn keyword pythonInclude        np pd tf sp
" kwargs
syn match   pythonFunction       /\h\w*\ze=/
" Additional operators
syn match   pythonOperator       #[+=\*/-]#

" I want the matrix multiplication operator to be colored
hi link pythonMatrixMultiply pythonOperator

" Conventions from 
" Deep Learning by Ian Goodfellow, Aaron Courville and Yoshua Bengio
syn keyword linalgScalar a b c d
syn keyword linalgVector e u v w x y z
syn keyword linalgMatrix A B C D I E H X Y Z


hi linalgScalar term=italic      cterm=italic      gui=italic
hi linalgVector term=bold,italic cterm=bold,italic gui=bold,italic
hi linalgMatrix term=bold,italic cterm=bold,italic gui=bold,italic
