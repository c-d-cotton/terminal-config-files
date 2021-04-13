#!/usr/env/bin bash
# these are the commands I always include in my bashrc
# BASH_PREAMBLE_START_COPYRIGHT:{{{
# Christopher David Cotton (c)
# http://www.cdcotton.com
# BASH_PREAMBLE_END:}}}

projectdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/"


#SETTINGS:{{{1
#COLOURS:{{{2
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
#HISTORY:{{{2
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=100000

# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups  

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"

#history -a with PROMPT appends to history after each command. It is automatically loaded hwen I open a new terminal but not when I go back to an old terminal. I can load the history file for an old terminal using history -r.

#INTERACTIVE ONLY:{{{2
case $- in
    *i*) 
        #Change Ctrl-w so that deletes to punctuation not the whole way:
        stty werase undef
        # bind -r '\C-w'
        # #bind '\C-w:unix-filename-rubout'
        # bind '\C-w:backward-kill-word'
        bind '\C-w:backward-kill-word'
        #Open automatically in tmux:
        # [[ -z "$TMUX" ]] && [[ -n "$(command -v tmux)" ]] && exec tmux

        ;;
esac

#MISC:{{{2
#Add extglob i.e. !(large)
shopt -s extglob

# #Set dbus-launch otherwise okular doesn't work:
# export $(dbus-launch)

#Set star to include dot files
shopt -s dotglob

#Set editor as Vim when changing long commands
export VISUAL="vim"
export EDITOR="$VISUAL"

#Use Vi shortcuts in bash:
#set -o vi

#Reduce prompt:
export PS1="\w \$"

# Remove XOFF - prevents Ctrl + s from freezing Vim:
stty -ixon

# turn off bell sound when error - get this with Kinesis keyboard
# if means implement only if interactive shell
if [[ "$-" =~ "i" ]]; then
    bind 'set bell-style none'
fi

#Options in my original bashrc that I didn't really understand but don't want to delete.

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ALIASES:{{{1
# BASH COMMAND LINE FUNCTIONS:
alias cp='cp --interactive'
alias mv='mv --interactive'

lstex () { ls | grep .tex; }
lspdf () { ls | grep .pdf; }
lstxt () { ls | grep .txt; }

# GENERAL FUNCTIONS:{{{1
# allcode-list:{{{2
allcode() {
    if [ ! -f "$projectdir"custom/allcode.txt ]; then
        echo "need to create terminal-config-files/custom/allcode.txt file containing code list"
        return 1
    fi
    # "$projectdir"submodules/allcode-list/getallcode_func.py --files_aslines "$(cat "$projectdir"custom/allcode.txt)"
    "$projectdir"submodules/allcode-list/getallcode_func.py --files_infile "$projectdir"custom/allcode.txt
}
allcode2() {
    "$projectdir"submodules/allcode-list/getallcode_func.py "$@"
}

# common-section:{{{2
commonsectionsupdate() {
    if [ ! -f "$projectdir"custom/allcode.txt ]; then
        echo "need to create terminal-config-files/custom/allcode.txt file containing code list"
        return 1
    fi
    if [ ! -d "$projectdir"custom/commonsections/ ]; then
        echo "need to create terminal-config-files/custom/commonsections/ folder containing common sections"
        return 1
    fi
    "$projectdir"submodules/common-section/common_section_func.py --files_aslines "$(allcode)" "$projectdir"custom/commonsections/
}
commonsectionsupdate2() {
    "$projectdir"submodules/common-section/common_section_func.py "$@"
}

# grepcode:{{{2
grepcode() {
    if [ ! -f "$projectdir"custom/allcode.txt ]; then
        echo "need to create terminal-config-files/custom/allcode.txt file containing code list"
        return 1
    fi
    "$projectdir"submodules/grepcode/grepcode_func.py --files_aslines "$(allcode)" "$@"
}
grepcode2() {
    "$projectdir"submodules/grepcode/grepcode_func.py "$@"
}

# infrep:{{{2
infrep() {
    if [ ! -f "$projectdir"custom/allcode.txt ]; then
        echo "need to create terminal-config-files/custom/allcode.txt file containing code list"
        return 1
    fi
    "$projectdir"submodules/infrep/run/infrep.py --files_aslines "$(allcode)" "$@"
}
infrep2() {
    "$projectdir"submodules/infrep/run/infrep.py "$@"
}
pathmv() {
    if [ ! -f "$projectdir"custom/allcode.txt ]; then
        echo "need to create terminal-config-files/custom/allcode.txt file containing code list"
        return 1
    fi
    "$projectdir"submodules/infrep/run/pathmv.py --files_aslines "$(allcode)" "$@"
}
pathmv2() {
    "$projectdir"submodules/infrep/run/pathmv.py "$@"
}

# APPLICATION SPECIFIC FUNCTIONS:{{{1
#GIT/GITHUB:{{{2
gitra () {
    echo 'reset'
    git reset
    # this is necessary if I'm including a file that was in my gitignore or excluding a file that was not in my gitingore
    # needs to come after git reset
    git rm -r --cached .
    echo 'add'
    git add .
}
gitdiff2 () {
    git diff HEAD^ HEAD;
}

#INFO FUNCTIONS{{{2
#Echo Info on Functions I forget:
tarinfo () { echo "tar -zxvf, z=uncompress with gzip, x=extract to disk from archive, v=verbose, f=read archive from data.tar.gz"; }

# TRASH:{{{2
trash () {
    ~/.terminal-config-files/trash.sh "$@"
}
