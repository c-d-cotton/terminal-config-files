" BASIC DEFINITIONS{{{1
if has('win32') || has ('win64')
    let $VIMHOME = $HOME."/vimfiles/"
else
    let $VIMHOME = $HOME."/.vim/"
endif

" PLUGINS{{{1
" PATHOGEN AND STARTIF:{{{2
if filereadable($VIMHOME . 'autoload/pathogen.vim')
    execute pathogen#infect()

    " turn filetype plugin on
    " only do this if not already turned on
    " otherwise this option reloads folding
    " so if I've set foldmethod=expr, it converts the folding vim uses to the Vim default rather than my preferred type
    " also need to do this with syntax
    if !exists("runfiletypepluginalready")
        filetype plugin on
        let runfiletypepluginalready=1
    endif

"FASTFOLD:{{{2
let g:tex_fold_enabled=1

"GUNDO:{{{2
" nnoremap <F5> :GundoToggle<CR>
" if has('python3')
"     let g:gundo_prefer_python3 = 1
" endif

"SCREEN:{{{2
nnoremap <Leader>jo :ScreenShell<CR>
noremap <Leader>jd :ScreenSend<CR>
noremap <Leader>jq :ScreenQuit<CR>

let g:ScreenShellHeight=15

"TMUX-NAVIGATOR:{{{2
" Tmux shortcuts in insert mode:
inoremap <C-h> <Esc>:TmuxNavigateLeft<cr>
inoremap <C-j> <Esc>:TmuxNavigateDown<cr>
inoremap <C-k> <Esc>:TmuxNavigateUp<cr>
inoremap <C-l> <Esc>:TmuxNavigateRight<cr>

"Save when leaving vim window into tmux:
let g:tmux_navigator_save_on_switch = 1

"ULTISNIPS:{{{2
" Set all filetypes to be latex (otherwise some generate as plaintex):
let g:tex_flavor='latex'

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

function! BADDTEX()
let filename = $VIMHOME . 'Ultisnips/tex.snippets'
execute ':badd ' . filename
endfunction
autocmd FileType tex :call BADDTEX()
function! BADDBIB()
let filename = $VIMHOME . 'Ultisnips/bib.snippets'
execute ':badd ' . filename
endfunction
autocmd FileType bib :call BADDBIB()

function! USE()
let my_filetype = &filetype
execute ':sp ' . $VIMHOME . 'UltiSnips/' . my_filetype . '.snippets'
endfunction
command! USE call USE()
function! SPUSE()
let my_filetype = &filetype
execute ':sp ' . $VIMHOME . 'UltiSnips/' . my_filetype . '.snippets'
endfunction
command! SPUSE call SPUSE()
function! VSPUSE()
let my_filetype = &filetype
execute ':vsp ' . $VIMHOME . 'UltiSnips/' . my_filetype . '.snippets'
endfunction
command! VSPUSE call VSPUSE()

command! USUPDATE call UltiSnips#RefreshSnippets()

" ENDIF:{{{2
" ends if that began before ran pathogen
" only runs if pathogen.vim exists
endif

"GENERAL SETTINGS:{{{1
"BACKSPACE:{{{2
" Backspace normal (can delete after escape following insert):
set backspace=indent,eol,start

"BACKUP:{{{2
set noswapfile

" don't ask to reload when leave window without saving
" in combination with the bufleave autosave, this seems to do autowrite (which wasn't working on it's own).
" set hidden


"BASH:{{{2
" need this to get functions etc. defined in bashrc
let $BASH_ENV = "$HOME" . "/.bashrc"

" Setting bash as main shell so call bash aliases automatically
" This causes errors if I change my bashrc.
fun! BASHRCOFF()
    let $BASH_ENV = ""
endfun
command! BASHRCOFF call BASHRCOFF()
fun! BASHRCON()
    let $BASH_ENV = "$HOME" . "/.bashrc"
endfun
command! BASHRCON call BASHRCON()


"BASH-LIKE COMMAND MENU MAPPINGS:{{{2
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

"COLORS:{{{2
" Adding colours to Vim:
set t_Co=256

"COMMENTS:{{{2
" Remove auto-commenting of next line:
" r is insert the current comment leader when press enter
" o is automatically insert the current comment leader after hitting o or O.
set formatoptions-=ro

"COMPLETION:{{{2
" means I don't select files by tab
set wildmenu
" show list with all files satisfying completion
set wildmode=list:longest
" turn off more when listing files
set nomore
" means that 1.out 1.txt shown in that order rather than reversed due to low priority for .out
set suffixes=off

"FOLDING:{{{2

if &foldmethod == "manual"
    set foldmethod=marker
endif

" GVIM:{{{2
:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar

"INDENTATION:{{{2
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces

" Each line has same indentation as previous line:
set autoindent
" set cindent "I read this was better but I found it annoying and unintuitive

" display continued line with same indent:
" Not always available. Would prefer to use has() function but didn't work so do silent call instead.
" if has("breakindent")
"     set breakindent
" endif
silent! set breakindent

" INTERNET:{{{2
" note can also call default browser via default internet command gx

function! GoogleChrome()
    let website=expand("<cfile>")
    " echo l:website
    exec 'silent !google-chrome-stable ' . l:website . " &>/dev/null"
    redraw!
endfunction

function! GoogleChromeIncognito()
    let website=expand("<cfile>")
    " echo l:website
    exec 'silent !google-chrome-stable --incognito ' . l:website . " &>/dev/null"
    redraw!
endfunction

nnoremap <Leader>gc :call GoogleChrome()<CR>
nnoremap <Leader>gd :call GoogleChromeIncognito()<CR>

" LEADER:{{{2
" let mapleader = ","

"NUMBERING:{{{2
set number " add numbers to side of screen
set rnu " turn on relative number

" SCROLLOFF:{{{2
" scrolloff=0 is normally the default
" but in cygwin default appears to be wrong as of 20191231 so set to be 0 just in case
set scrolloff=0

 "SEARCH:{{{2
" Highlighted search:
set hlsearch

" Start searching from beginning
" set incsearch

" Only apply case when non-lower case:
" Turned off because impacts substitute
" set ignorecase
" set smartcase

" if I want to search for a term ignoring case then do /term\c i.e. add \c to
" the end to get it to be case insensitive

" SOUND:{{{2
" turn off all error sounds - otherwise kinesis keyboard can give error sounds
if has("gui")
    set belloff=all
endif

"SPELL:{{{2
" use Ctrl-n and Ctrl-p to go through words in dictionary
set complete+=kspell
" set dictionary to be english
set dictionary+=english

 "STATUS:{{{2
set laststatus=2
" set noshowmode "don't show insert statement

 "SYNTAX {{{2
" resetting the filetype in vundle combined with syntax on screws up my tex folding for reasons that are not entirely clear to me
if !exists("runsyntaxalready")
    syntax on
    let runsyntaxalready=1
endif

" UNDO:{{{2
" I decided this wasn't really necessary
" if has("persistent_undo")
" 
"     set undodir=$VIMHOME/undo "need to generate this each time
"     set undofile
" endif

"UPDATE:{{{2
" Save frequently to avoid issues.
" autocmd BufLeave,BufReadPre,CursorHold,CursorHoldI,FocusLost,FocusGained,InsertEnter,InsertLeave * :call RefreshVim()

" What I used to use before Focusgained worked
" autocmd BufLeave,BufReadPre,CursorHold,CursorHoldI,InsertEnter,InsertLeave * :silent! update

" automatically save when move to different buffer or when leave vim
" also when don't move cursor (since I want to save changes in current file)
autocmd BufEnter,BufLeave,FocusLost,FocusGained,CursorHold,CursorHoldI,InsertEnter * :silent! update

" automatically reload vim when changes made
set autoread

 "WINDOWS:{{{2
set splitbelow
set splitright

"WRAP:{{{2
" turn off wrapping in vim files
au FileType vim setlocal textwidth=0


" FILETYPE SETTINGS:{{{1
" removed on 20190524 since don't think needed
" au BufNewFile,BufRead *.cls set filetype=tex

" add hyphens to word characters
autocmd FileType tex :set iskeyword+=-
autocmd FileType bib :set iskeyword+=-

" COMMANDS:{{{1
" COPY:{{{2
" Copy Paste from X11 Clipboard
" based on https://vim.fandom.com/wiki/In_line_copy_and_paste_to_system_clipboard
" for when can't access the register as -clipboard not available in vim version
vnoremap <Leader>y y: call system("xclip -i -selection clipboard", getreg("\""))<CR>
" nnoremap <Leader>p :set paste<CR>i<CR><CR><Esc>k:.!xclip -o<CR>JxkJx:set nopaste<CR>
command! XCP :r!xclip -o
nnoremap <Leader>p :XCP<CR>

" cygwin copy and paste
" normal register doesn't work since cygwin access /dev/clipboard to copy/paste from clipboard
" copy
command! CYGC :'<,'>w !cat > /dev/clipboard
" paste
command! CYGP :r !cat /dev/clipboard

" LATEX RUN:{{{2
fun! PDFLATEX()
    if &ft=='tex'
        cd %:p:h
        let execstr = "!pdflatex " . shellescape(expand("%:t:r"))
        exec execstr
        cd -
    else
        echo "this is not a tex file"
    endif
endfun
command! PDFLATEX call PDFLATEX()
nnoremap <silent> <Leader>lp <Esc>:PDFLATEX<CR>

fun! BIBTEX()
    if &ft=='tex'
        cd %:p:h
        let execstr = "!bibtex " . shellescape(expand("%:t:r"))
        exec execstr
        cd -
    else
        echo "this is not a tex file"
    endif
endfun
command! BIBTEX call BIBTEX()
nnoremap <silent> <Leader>lb <Esc>:BIBTEX<CR>

" GO TO GIT PROJECT DIR
fun! ChangeProjectDir()
    let dir = finddir('.git/..', ';')
    " echo the directory just so I know where I'm going
    echo 'cd to: ' . dir
    if dir == ''
        echo "Not in a git directory"
    else
        let execstr = 'cd ' . dir
        exec execstr
    endif
endfun
nnoremap <Leader>a :call ChangeProjectDir()<CR>

" LATEX VIEW PDF:{{{2
" to set specify something like
" let g:pdftexviewer == "skim_forwardsearch"
function! PdfTex()

    let extension = fnameescape(expand("%:e"))
    if extension != 'tex'
        echo "filename should end with .tex"
        return 1
    endif

    let filestem = fnameescape(expand("%:p:r"))
    let filestemescape = fnameescape(expand("%:p:r"))

    " get string to run to open pdf
    " silent removes main messages from running. However, add &>/dev/null to remove random error messages
    " final & ensures that program continues running with setsid
    if g:pdftexviewer == ""
        echo "Specify g:pdftexviewer to use this function."
        return 1
    elseif g:pdftexviewer == "evince_basic"
        let execstr = 'silent !setsid evince ' . filestemescape . '.pdf' . ' &>/dev/null &'
    elseif g:pdftexviewer == "okular_forwardsync"
        let execstr = 'silent !setsid okular ' . filestemescape . '.pdf' . '\#src:' . line(".") . filestemescape . '.tex' . ' &>/dev/null &'
    elseif g:pdftexviewer == "okular_basic"
        let execstr = 'silent !setsid okular ' . filestemescape . '.pdf' . ' &>/dev/null &'
    elseif g:pdftexviewer == "skim_forwardsearch"
        " note didn't use setsid as it isn't on macbook by default
        let execstr = 'silent !/Applications/Skim.app/Contents/SharedSupport/displayline ' . line(".") . ' ' . filestemescape . '.pdf' . ' &>/dev/null &'
    elseif g:pdftexviewer == "sumatra_cygwin_forwardsearch"
        let execstr = "silent !setsid '/cygdrive/c/Program Files (x86)/SumatraPDF/SumatraPDF.exe' -reuse-instance -forward-search '" . filestemescape . ".tex' " . line(".") . " '" . filestemescape . ".pdf' &"
    elseif g:pdftexviewer == "winexplorer_basic"
        let execstr = "!explorer.exe " . '"file:\\\\' . shellescape(expand('%:p:h')) . '\' . shellescape(expand('%:t:r')) . '.pdf"'
    else
        echo "g:pdftexviewer is misspecified."
        return 1
    endif

    exec execstr
    " echo execstr
    " redraws the window otherwise get black bars etc.
    redraw!
endfunction

" mapping
nmap <Leader>lb :call PdfTex()<CR>

" MAPPINGS AND SHORTCUTS:{{{1

" Insert current path and file:
:inoremap <Leader>wcd <C-R>=fnameescape(expand("%:p:h"))<CR>
:inoremap <Leader>we <C-R>=fnameescape(expand("%:p"))<CR>

" Shortcuts for changing directory:
nnoremap <Leader>e :e <C-R>=fnameescape(expand("%:p:h")) . "/" <CR>
nnoremap <Leader>sp :sp <C-R>=fnameescape(expand("%:p:h")) . "/" <CR>
nnoremap <Leader>vsp :vsp <C-R>=fnameescape(expand("%:p:h")) . "/" <CR>
nnoremap <Leader>cd :cd <C-R>=fnameescape(expand("%:p:h")) . "/" <CR>

" redraw quickly
command! R redraw!

" close quickly
command! Q wqa

" turn off highlighting two letter command
nnoremap <Leader>h :noh<cr>

" shortcuts for navigating command menu
:cnoremap <C-S-b> <S-Left>
:cnoremap <C-S-f> <S-Right>

