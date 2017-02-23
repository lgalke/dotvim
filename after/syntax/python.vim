syn keyword pythonBuiltinObj self
syn keyword pythonInclude    np pd tf sp

syn keyword linalgScalar a b c d
syn keyword linalgVector e u v w x y z
syn keyword linalgMatrix A B C D I E H X Y Z


hi linalgScalar term=italic      cterm=italic      gui=italic
hi linalgVector term=bold,italic cterm=bold,italic gui=bold,italic
hi linalgMatrix term=bold,italic cterm=bold,italic gui=bold,italic
