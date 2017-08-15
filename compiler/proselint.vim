if exists("current_compiler")
  finish
endif

let current_compiler = "proselint"

" quadflor_paper.tex:665:3: weasel_words.very Substitute 'damn' every time you're inclined to write 'very;' your editor will delete it and the writing will be just as it should be.
CompilerSet errorformat=%f:%l:%c:\ %m
CompilerSet makeprg=proselint\ %

