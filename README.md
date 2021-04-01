# Introduction
Basic code to help me set up a terminal to my liking on UNIX.

# Setup Terminal
## Setup Submodules
Run setup_submodules.sh to add in required submodules. Needed to run setup_vimfiles.sh

## How to Run
Two choices over what to run:
- setup.sh: Runs everything (including setting up vimfiles). Probably makes sense to run on any Unix install. May not make sense to run on Windows since it clutters up the home directory with observable dot files.
- setup_vimfiles.sh: Only setups up vimfiles. Probably only makes sense to run on Windows when I only want to set up vim.

When running both setup.sh and setup_vimfiles.sh, I need to specify whether I want to link or copy across the files. To do this, I have to include either the necessary argument "link" or "copy", so I would run:
- setup.sh link OR setup.sh copy
- setup_vimfiles.sh link OR setup_vimfiles.sh copy

In general, it seems preferable to link, since this means I can typically easily git pull changes and also easily git push any changes. Note that I source rather than link/copy the bashrc_always.sh and vimrc_always.vim files.

## Windows-Specific Issues
- Since the scripts are bash, I will need git bash or cygwin to run them
- If I only install vimfiles, I can also add vimrc_always.vim by adding `so LOCATIONOFVIMRCALWAYS/vimrc_always.vim` to my `~/_vimrc` file
- If I don't have git bash or cygwin, I can just run the following commands to install vimfiles only (note since I'm copying across the full folders, it would be difficult to update these folders without replacing any changes/additions I've made):
```
rsync -a FOLDER/submodules/ ~/vimfiles/bundle/
rsync -a FOLDER/submodules/vim-pathogen/autoload/ ~/vimfiles/autoload/
rsync -a FOLDER/after/ ~/vimfiles/after/
rsync -a FOLDER/UltiSnips/ ~/vimfiles/UltiSnips/
```
- I normally just set up only Vim on Windows, but if I really want to have a Unix environment, I could also run these scripts in Git Bash or Cygwin, but I haven't fully explored how well this works

Quick summary of issues:
- Can either copy or link across files from the folder. Link is preferred since then I can easily update the git folder to add changes and easily push changes as well. However, this may not be ideal on Windows
- Windows: If only want to add Vim, can just run setup_vimfiles.sh



This should work on any standard Unix shell. To run basic terminal setup i.e. everything except installing Vim submodules:
cd ~
wget https://cdcotton.com/code/modules_zipped/terminal-config-files
./terminal-config-files/setup.sh

To start tmux automatically in Bash, add the following command to the bashrc:
```
[[ -z "$TMUX" ]] && [[ -n "$(command -v tmux)" ]] && tmux
```

See below to also install Vim submodules.

To delete the folder after usage:
```
chmod -R 755 terminal-config-files
rm -r terminal-config-files terminal-config-files.zip
cd -
```

# Purpose of Files
after/: Contains all vim files
bashrc_always.sh: Always include in bashrc
inputrc.sh: Use in bash completions
minttyrc: Sets up xterm for cygwin
submodules/: Contains all vim submodules
tmux.conf: tmux configuration file
UltiSnips/: Contains all ultisnips folders
vimrc_always.vim: Always include in vimrc
Xresources: Set up display for Xterm and URXVT


# Additional Bashrc Functions
If I added a list of code (which can include comments starting with # and blank lines that will be ignored) to terminal-config-files/custom/allcode.txt then I can use the following additional functions:
- allcode: Produces a list of all code that the user might wish to modify by walking through the folders/files in allcode.txt (ignoring standard non-code folders such as .git). See submodules/allcode-list for details.
- infrep: Replaces arg1 with arg2 for all allcode files. Can also use Python regex. See submodules/infrep/ for details.
- pathmv: Move and also replace any absolute references to the files that are being moved with their new location for all allcode files. See submodules/infrep/ for details.
- grepcode: Searches through all the allcode files to look for arg. See submodules/grepcode/ for details.

If I have defined terminal-config-files/custom/allcode.txt and terminal-config-files/custom/commonsections/, which should be a folder containing sections of code that all start and end with a unique line, then I can run:
- commonsectionsupdate: The version of the common section in the custom folder is copied across to any other common sections in allcode. Allows quick changes to these common sections. See submodules/common-section/ for details.

# Vim Submodules
To install Vim submodules on a Unix shell run:
```
./terminal-config-files/setup_vim.sh
```

# Windows
To install my Vimrc in Windows:
- Get location of Windows vimrc from :version
- Source vimrc\_always in the vimrc

To install Vim submodules:
- Download vim-pathogen/master/autoload/pathogen.vim to $VIMFILES\autoload\pathogen.vim
- Download vim submodules (listed in `setup_vim.sh`) to $VIMFILES\bundle\ except for screen, vim-tmux-focus-events, vim-tmux-navigator, which are not needed in Windows.
- 
To run Vim in Windows, also run:
```
cp -r ~/.vim ~/vimfiles
```

To update font:
```
if has('gui_running')
  set guifont=Consolas:h12
endif
```
To get list of fonts, look at Edit > Select Fonts list
