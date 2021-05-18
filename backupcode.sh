#!/usr/bin/env bash
set -e

projectdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/"

if [ -f "$projectdir"/custom/pythonpath.txt ]; then
    pythonpath="$(cat "$projectdir"custom/pythonpath.txt)"
    pythonpath="${pythonpath/#\~/$HOME}"
else
    pythonpath="python3"
fi


if [ ! -f "$projectdir"/custom/allcode.txt ]; then
    echo "need to define custom/allcode.txt to use this backup function"
    exit 1
fi

# get allcode
allcode=$("$pythonpath" "$projectdir"submodules/allcode-list/getallcode_func.py --files_infile "$projectdir"custom/allcode.txt)

# now run allcode backup
"$pythonpath" "$projectdir"submodules/regbackup/run/backupcode.py ~/temp/regbackup/code/ --files_aslines "$allcode" -f M5 -f H1 -f d1 -f d10 -f m1

# now run alldirs backup
"$pythonpath" "$projectdir"submodules/regbackup/run/backupdirs.py ~/temp/regbackup/dirs/ --files_infile "$projectdir"custom/allcode.txt -f H1 -f d1 -f d10 -f m1

# get location of zip folder (might want to put in syncing folder e.g. Dropbox)
if [ -f "$projectdir"/custom/backupzipfolder.txt ]; then
    backupzipfolder="$(cat "$projectdir"custom/backupzipfolder.txt)"
    backupzipfolder="${backupzipfolder/#\~/$HOME}"
else
    backupzipfolder=~/temp/regbackup/
fi

if [ ! -d "$backupzipfolder" ]; then
    echo "$backupzipfolder in custom/backupzipfolder.txt does not exist"
    exit 1
fi

# now do zip backup for code
"$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/code/d1/ "$backupzipfolder"/code/d1/ --maxbackups 12

"$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/code/d10/ "$backupzipfolder"/code/d10/ --maxbackups 10

"$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/code/m1/ "$backupzipfolder"/code/m1/

# now do zip backup for code
"$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/dirs/d1/ "$backupzipfolder"/dirs/d1/ --maxbackups 12

"$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/dirs/d10/ "$backupzipfolder"/dirs/d10/ --maxbackups 10

"$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/dirs/m1/ "$backupzipfolder"/dirs/m1/

