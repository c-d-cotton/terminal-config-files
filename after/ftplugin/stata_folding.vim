"{{{1 Introduction
setlocal foldmethod=expr
setlocal foldexpr=StataFold(v:lnum)
"{{{1 Functions
" I took this from the other file. I'm not sure how it works with the
" environments ATM.

function! StataFold(lnum)
    let line = getline(a:lnum)

    if line =~ '^program '
        return 'a1'
    endif
    if line =~ '^end$'
        return 's1'
    endif

    if line =~ '{{{1$'
        return '>1'
    endif
    if line =~ '}}}1$'
        return '<2'
    endif
    if line =~ '{{{2$'
        return '>2'
    endif
    if line =~ '}}}2$'
        return '<2'
    endif
    if line =~ '{{{3$'
        return '>3'
    endif
    if line =~ '}}}3$'
        return '<3'
    endif
    if line =~ '{{{$'
        return 'a1'
    endif
    if line =~ '}}}$'
        return 's1'
    endif

    return '='
endfunction
