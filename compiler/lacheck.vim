if exists("current_compiler")
  finish
endif

let current_compiler = "lacheck"

CompilerSet errorformat="%f",\ line\ %l:\ %m
CompilerSet makeprg=lacheck\ %
