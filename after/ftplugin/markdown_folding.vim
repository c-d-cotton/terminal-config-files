" Don't remember writing this myself. However, seems to work well.
" VIM_PREAMBLE_START_NOPREAMBLE:{{{
" VIM_PREAMBLE_END:}}}
function! MarkdownFolds()
    let thisline = getline(v:lnum)
    if match(thisline, '^#') >=0 "so the line starts with  #???
        return ">1"
    else
        return "="
    endif
endfunction
setlocal foldmethod=expr
setlocal foldexpr=MarkdownFolds()
