# Introduction
Basic code to help me set up a terminal to my liking on UNIX.

# Setup Terminal
## Setup Submodules
Run setup_submodules.sh to add in required submodules.

## How to Run
Two choices over what to run:
- setup.sh: Runs everything except setting vimfiles. Probably makes sense to run on any Unix install. May not make sense to run on Windows since it clutters up the home directory with observable dot files.
- setup_vimfiles.sh: Only setups up vimfiles. Probably only makes sense to run on Windows when I only want to set up vim.

When running both setup.sh and setup_vimfiles.sh, I need to specify whether I want to link or copy across the files. To do this, I have to include either the necessary argument "link" or "copy", so I would run:
- setup.sh link OR setup.sh copy
- setup_vimfiles.sh link OR setup_vimfiles.sh copy

In general, it seems preferable to link, since this means I can typically easily git pull changes and also easily git push any changes. Note that I source rather than link/copy the bashrc_always.sh and vimrc_always.vim files.

## Additional Bashrc Commands:
To start tmux automatically in Bash, add the following command to the bashrc:
```
[[ -z "$TMUX" ]] && [[ -n "$(command -v tmux)" ]] && tmux
```

## Windows-Specific Issues
There is probably no need to add any non-Vim files to Windows.

The easiest way to add Vim files to Windows is just to copy them over from Unix where I've already downloaded them. If the Unix version has links, I should "cp -rL" this to a new location before copying that to Windows to replace the links with files. I can then also just download the vimrc_always.vim files and source it with `so LOCATIONOFVIMRCALWAYS/vimrc_always.vim`.

Alternatively, I can run ./setup_vimfiles.sh in git bash or cygwin and copy over the vimrc_always.vim file.

Finally, I can also just copy over the relevant folders bit by bit:
rsync -a FOLDER/submodules/package/ ~/vimfiles/bundle/package/
rsync -a FOLDER/submodules/vim-pathogen/autoload/ ~/vimfiles/autoload/
rsync -a FOLDER/after/ ~/vimfiles/after/
rsync -a FOLDER/UltiSnips/ ~/vimfiles/UltiSnips/

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
- backupcode.sh: Backs up my code and my directories in the allcode.txt file to ~/temp/regbackup (two versions of backups: code only and full directories). Does backups at varying frequencies and also adds zipped backups. If specify custom/backupzipfolder.txt then the zipped version of the folders are saved in a separate location specified by that file. If specify custom/pythonpath.txt then python is called from the path in that file (necessary sometimes if the file is called through cron since cron may not call the correct python3 version).

If I have defined terminal-config-files/custom/allcode.txt and terminal-config-files/custom/commonsections/, which should be a folder containing sections of code that all start and end with a unique line, then I can run:
- commonsectionsupdate: The version of the common section in the custom folder is copied across to any other common sections in allcode. Allows quick changes to these common sections. See submodules/common-section/ for details.

If I have defined terminal-config-files/custom/gitdir/rootdirs.txt (a list of folders each containing git projects) and/or terminal-config-files/custom/gitdir/singledirs.txt (a list of git projects) then I can run:
- gitalllist: Get list of git project locations
- gitalldetails: Get details on current commit status of git projects
- gitallcommit: Commit all projects with uncommitted changes with the same project name. Warns you if there are new added files in these projects.
- gitallpull: Pull all changes for projects
- gitallpush: Push all changes for projects

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
