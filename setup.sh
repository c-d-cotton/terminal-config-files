#!/usr/bin/env bash

set -e

projectdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/"

# Get Initial Arguments:{{{1
if [ "$1" != "link" ] && [ "$1" != "copy" ]; then
    echo "need to specify 'link' or 'copy' as arguments depending on whether want to link or copy the files across"
    exit 1
fi

# Functions for setting up files/folders:{{{1
if [ "$1" == "link" ]; then

    linkorcopy() {
        ln -snf "$1" "$2"
    }
else
    linkorcopy() {
        rsync -a "$1" "$2"
    }
fi


# Bashrc/Vimrc:{{{1
# create bashrc
if [ ! -f ~/.bashrc ]; then
    touch ~/.bashrc
fi

# add terminalconfigfiles variable if not already there
# the marker means that even if I change the source folder, I'll still replace the old text
if ! grep -q "# variable for terminalconfigfiles" ~/.bashrc; then
    echo "adding variable for terminalconfigfiles"
    echo "# variable for terminalconfigfiles" >> ~/.bashrc
fi

sed -i'.bak' 's|.*# variable for terminalconfigfiles|terminalconfigfiles='"$projectdir"' # variable for terminalconfigfiles|g' ~/.bashrc

# add marker for source of bashrc if not already there
# the marker means that even if I change the source folder, I'll still replace the old text
if ! grep -q "# source bashrc_always.sh" ~/.bashrc; then
    echo "adding bashrc_always.sh to bashrc"
    echo "# source bashrc_always.sh" >> ~/.bashrc
fi

sed -i'.bak' 's|.*# source bashrc_always.sh|\. '"$projectdir"'bashrc_always.sh # source bashrc_always.sh|g' ~/.bashrc

# create vimrc
if [ ! -f ~/.vimrc ]; then
    touch ~/.vimrc
fi

# same for vimrc
if ! grep -q '" source vimrc_always.vim' ~/.vimrc; then
    echo 'adding vimrc_always.vim to vimrc'
    echo '" source vimrc_always.vim' >> ~/.vimrc
fi
# if ! grep -q " source vimrc_always.vim" ~/.vimrc; then

sed -i'.bak' 's|.*" source vimrc_always.vim|so '"$projectdir"'vimrc_always.vim " source vimrc_always.vim|g' ~/.vimrc

# Other Bash Scripts:{{{1
# add Xresources (for xterm font config)
linkorcopy "$projectdir"Xresources ~/.Xresources
if [ -n "$(command -v xrdb)" ]; then
    # allow error in case no DISPLAY variable defined
    set +e
    xrdb ~/.Xresources
    set -e
fi

# add minttyrc (terminal display config for cygwin)
linkorcopy "$projectdir"minttyrc ~/.minttyrc

# add inputrc
# this defines keyboard stuff not just in bash but also vim etc.
linkorcopy "$projectdir"inputrc.sh ~/.inputrc

# add tmux.conf
linkorcopy "$projectdir"tmux.conf ~/.tmux.conf


