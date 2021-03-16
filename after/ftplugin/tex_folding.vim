" VIM_PREAMBLE_START_COPYRIGHT:{{{
" Christopher Cotton (c)
" http://www.cdcotton.com
" VIM_PREAMBLE_END:}}}
"{{{1 Introduction
"Based on Matthias Vogelgesang
setlocal foldmethod=expr
setlocal foldexpr=TeXFold(v:lnum)
"{{{1 Functions
" I took this from the other file. I'm not sure how it works with the
" environments ATM.
if !exists('g:tex_fold_additional_envs')
    let g:tex_fold_additional_envs = []
endif
let g:tex_fold_additional_envs = []

function! TeXFold(lnum)
    let line = getline(a:lnum)
    let envs = '\(' . join(['table', 'figure', 'align', 'lstlisting', 'theorem', 'proposition', 'conjecture', 'proof', 'lemma', 'remark', 'example', 'definition','assumption', 'corollary', 'verbatim', 'comment', 'tikzpicture','exercise','solution'] + g:tex_fold_additional_envs, '\|') . '\)'

    if line =~ '^\\appendix'
        return '>1'
    endif

    if line =~ '^\\pagebreak'
        return '>1'
    endif

    if line =~ '^\\newpage'
        return '>1'
    endif

    if line =~ '^\\bibliography{'
        return '>1'
    endif

    if line =~ '^% BIBLIOGRAPHY_CALL_START.'
        return '>1'
    endif

    if line =~ '^% \\bibliography{'
        return '>1'
    endif

    if line =~ '^\\end{document}'
        return '>1'
    endif

    if line =~ '^%BEAMER_PREAMBLE\.'
        return '>1'
    endif

    if line =~ '^%END_BEAMER_PREAMBLE\.'
        return '<1'
    endif

    if line =~ '^%BEAMER_TITLE\.'
        return '>1'
    endif

    if line =~ '^%END_BEAMER_TITLE\.'
        return '<1'
    endif

    if line =~ '^%BEAMER_BIBLIOGRAPHY\.'
        return '>1'
    endif

    if line =~ '^%END_BEAMER_BIBLIOGRAPHY\.'
        return '<1'
    endif

    if line =~ '^%BEAMER_POSTAMBLE\.'
        return '>1'
    endif

    if line =~ '^% PREAMBLE_START\.'
        return '>1'
    endif

    if line =~ '^% PREAMBLE_END\.'
        return '<1'
    endif

    if line =~ '^\\part\*{'
        return '>1'
    endif

    if line =~ '^\\part{'
        return '>1'
    endif

    if line =~ '^\s*\\section'
        return '>1'
    endif

    if line =~ '^\s*\\subsection'
        return '>2'
    endif

    if line =~ '^\s*\\subsubsection'
        return '>3'
    endif

    " if line =~ '^\s*\\paragraph'
    "     return '>4'
    " endif

    " if line =~ '^\s*\\subparagraph'
    "     return '>5'
    " endif

    if line =~ '^\s*\\begin{frame}'
        return '>1'
    endif

    if line =~ '^\s*\\end{frame}'
        return '<1'
    endif

    if line =~ '^\s*\\begin{' . envs
        return 'a1'
    endif

    if line =~ '^\s*\\end{' . envs
        return 's1'
    endif

    " if line =~ '^\\newpage'
    "     return '>1'
    " endif

    if line =~ '%{{{1'
        return '>1'
    endif

    if line =~ '%}}}1'
        return '<1'
    endif

    if line =~ '%{{{2'
        return '>2'
    endif

    if line =~ '%}}}2'
        return '<2'
    endif

    if line =~ '%{{{3'
        return '>3'
    endif

    if line =~ '%}}}3'
        return '<3'
    endif

    if line =~ '%{{{4'
        return '>4'
    endif

    if line =~ '%}}}4'
        return '<4'
    endif

    if line =~ '%{{{5'
        return '>5'
    endif

    if line =~ '%}}}5'
        return '<5'
    endif


    if line =~ '%{{{'
        return 'a1'
    endif

    if line =~ '%}}}'
        return 's1'
    endif

    return '='
endfunction
