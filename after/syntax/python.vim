syn keyword pythonBuiltinObj self

syn keyword linalgScalar a b c d e
syn keyword linalgVector u v w x y z
syn keyword linalgMatrix A B C D I E J H X Y Z

syn keyword pythonInclude np pd tf sp


hi linalgScalar term=italic cterm=italic gui=italic
hi linalgVector term=bold,italic cterm=bold,italic gui=bold,italic
hi linalgMatrix term=bold,italic cterm=bold,italic gui=bold,italic
