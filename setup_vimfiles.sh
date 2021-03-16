#!/usr/bin/env bash
set -e

projectdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/"

# Get Initial Arguments:{{{1
if [ "$1" != "link" ] && [ "$1" != "copy" ]; then
    echo "need to specify 'link' or 'copy' as arguments depending on whether want to link or copy the files across"
    exit 1
fi
if [ "$2" != "" ]; then
    # add forwardslash at end
    if [ "${vimfolder: -1}" != "/" ]; then
        vimfolder="$vimfolder/"
    fi
else
    vimfolder=~/.vim/
fi

# Functions for setting up files/folders:{{{1
if [ "$1" == "link" ]; then

    linkorcopy() {
        source="$1"
        dest="$2"
        # ln -s needs no / at end to work the way I like
        if [ -d "$source" ]; then
            if [ "${source: -1}" == "/" ]; then
                source="${source:: -1}"
            fi
            if [ "${dest: -1}" == "/" ]; then
                dest="${dest:: -1}"
            fi
        fi
        ln -snf "$source" "$dest"
    }
else
    linkorcopy() {
        source="$1"
        dest="$2"
        # rsync needs / at end to work the way I like
        if [ -d "$source" ]; then
            if [ "${source:-1}" != "/" ]; then
                source="$source"/
            fi
            if [ "${dest:-1}" != "/" ]; then
                source="$dest"/
            fi
        fi
        rsync -a "$source" "$dest"
    }
fi


# Basics:{{{1
# make vim directory
if [ ! -d "$vimfolder" ]; then
    mkdir "$vimfolder"
fi

# After:{{{1
# make necessary folders
mkdir -p ~/.vim/after/ftplugin/
mkdir -p ~/.vim/after/syntax/

# link/copy across ftplugin files
for filename in $(ls "$projectdir"after/ftplugin/); do
    linkorcopy "$projectdir"after/ftplugin/"$filename" "$vimfolder"after/ftplugin/"$filename"
done

# link/copy across syntax files
for filename in $(ls "$projectdir"after/syntax/); do
    linkorcopy "$projectdir"after/syntax/"$filename" "$vimfolder"after/syntax/"$filename"
done


# Pathogen/Plugins:{{{1

# may as well copy across
rsync -a "$projectdir"submodules/vim-pathogen/autoload/ "$vimfolder"autoload/

# make folder for plugins
mkdir -p ~/.vim/bundle

# copy across plugins
for projectname in FastFold screen vim-tmux-focus-events tcomment_vim vim-eunuch vim-tmux-navigator; do
    if [ ! -e ~/.vim/bundle/"$projectname" ]; then
        rsync -a "$projectdir"submodules/"$projectname"/ "$vimfolder"bundle/"$projectname"/
    fi
done

# only add ultisnips if vim comes with python enabled
if [[ "$(vim --version)" == *"+python3"* ]]; then
    linkorcopy "$projectdir"submodules/ultisnips/ "$vimfolder"bundle/ultisnips/
elif [[ "$(vim --version)" == *"+python"* ]]; then
    linkorcopy "$projectdir"submodules/ultisnips-python2/ "$vimfolder"bundle/ultisnips/
else
    echo "Ultisnips not installed as missing python-enabled vim"
fi

# UltiSnips Snippets:{{{1
if [ ! -e "$vimfolder"UltiSnips/ ]; then
    mkdir "$vimfolder"UltiSnips/
fi
cd "$projectdir"UltiSnips/
for f in *; do
    linkorcopy "$projectdir"UltiSnips/"$f" "$vimfolder"UltiSnips/"$f"
done
cd - > /dev/null

