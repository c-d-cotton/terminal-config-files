" VIM_PREAMBLE_START_COPYRIGHT:{{{
" Christopher Cotton (c)
" http://www.cdcotton.com
" VIM_PREAMBLE_END:}}}
"{{{1 Introduction
setlocal foldmethod=expr
setlocal foldexpr=PythonFold(v:lnum)
"{{{1 Functions
" I took this from the other file. I'm not sure how it works with the
" environments ATM.

function! PythonFold(lnum)
    let line = getline(a:lnum)

    if line =~ '^def getprojectdir(filename):'
        return '='
    endif
    if line =~ '^def getabspathbyproject(project, pathinproject):'
        return '='
    endif
    if line =~ '^def importattr(modulefilename, func, modulesdict = modulesdict):'
        return '='
    endif
    if line =~ '^def abspathbyproject(project, pathinproject):'
        return '='
    endif


    " if line =~ '^def.*(.*):'
    if line =~ '^def.*(.*'
        return '>1'
    endif

    if line =~ '^class.*(.*):'
        return '>1'
    endif

    if line =~ '{{{1'
        return '>1'
    endif

    if line =~ '}}}1'
        return '<1'
    endif

    if line =~ '{{{2'
        return '>2'
    endif

    if line =~ '}}}2'
        return '<2'
    endif

    if line =~ '{{{3'
        return '>3'
    endif

    if line =~ '}}}3'
        return '<3'
    endif


    if line =~ '{{{'
        return 'a1'
    endif

    if line =~ '}}}'
        return 's1'
    endif

    return '='
endfunction
