#!/usr/bin/env bash
# just creates a folder containing my rc files that I can add to my code to backup
# also need to add this file to my crontab to run regularly
set -e

if [ ! -d ~/temp/rcfiles_sync/ ]; then
    mkdir -p ~/temp/rcfiles_sync/
fi

if [ -f ~/.bashrc ]; then
    \cp ~/.bashrc ~/temp/rcfiles_sync/bashrc
fi
if [ -f ~/.vimrc ]; then
    \cp ~/.vimrc ~/temp/rcfiles_sync/vimrc
fi
if [ -d ~/.anacron/ ]; then
    if [ -d ~/temp/rcfiles_sync/anacron/ ]; then
        rm -rf ~/temp/rcfiles_sync/anacron/
    fi
    cp -r ~/.anacron ~/temp/rcfiles_sync/anacron/
fi
if [ -f ~/.vimrc ]; then
    crontab -l > ~/temp/rcfiles_sync/crontab
fi

