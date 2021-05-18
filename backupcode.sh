#!/usr/bin/env bash
set -e

projectdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/"

# options:{{{
if [ -f "$projectdir"/custom/pythonpath.txt ]; then
    pythonpath="$(cat "$projectdir"custom/pythonpath.txt)"
    pythonpath="${pythonpath/#\~/$HOME}"
else
    pythonpath="python3"
fi

if [ -f "$projectdir"/custom/limitedbackups.txt ]; then
    limitedbackups=1
else
    limitedbackups=0
fi

# get location of zip folder (might want to put in syncing folder e.g. Dropbox)
if [ -f "$projectdir"/custom/backupzipfolder.txt ]; then
    backupzipfolder="$(cat "$projectdir"custom/backupzipfolder.txt)"
    backupzipfolder="${backupzipfolder/#\~/$HOME}"
    separatezipfolder=1
else
    backupzipfolder=~/temp/regbackup/
    separatezipfolder=0
fi

# options:}}}

# allcode backup:{{{
if [ ! -f "$projectdir"/custom/allcode.txt ]; then
    echo "need to define custom/allcode.txt to use this backup function"
    exit 1
fi

# get allcode
allcode=$("$pythonpath" "$projectdir"submodules/allcode-list/getallcode_func.py --files_infile "$projectdir"custom/allcode.txt)

if [ $limitedbackups == 1 ]; then
    allcodefreqs= '-f M5_2 -f H1_2 d1_2 -f d10_2 -f m1_2'
else
    allcodefreqs='-f M5 -f H1 -f d1 -f d10 -f m1'
fi

# now run allcode backup
"$pythonpath" "$projectdir"submodules/regbackup/run/backupcode.py ~/temp/regbackup/code/ --files_aslines "$allcode" $allcodefreqs
# allcode backup:}}}

# alldirs backup:{{{
if [ $limitedbackups == 1 ]; then
    alldirsfreqs= '-f d1_2 -f d10_1 -f m1_1'
else
    alldirsfreqs='-f H1 -f d1 -f d10 -f m1'
fi

# now run alldirs backup
"$pythonpath" "$projectdir"submodules/regbackup/run/backupdirs.py ~/temp/regbackup/dirs/ --files_infile "$projectdir"custom/allcode.txt $alldirsfreqs
# alldirs backup:}}}

# create zips:{{{
if [ ! -d "$backupzipfolder" ]; then
    echo "$backupzipfolder in custom/backupzipfolder.txt does not exist"
    exit 1
fi

# only do daily and 10day zip backups if not limited backups and have a separate zip folder
# otherwise do monthly zip backup

# now do zip backup for code
if [ $limitedbackups == 0 ] && [ $separatezipfolder == 1 ]; then
    "$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/code/d1/ "$backupzipfolder"/code/d1zip/ --maxbackups 12

    "$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/code/d10/ "$backupzipfolder"/code/d10zip/
else
    "$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/code/m1/ "$backupzipfolder"/code/m1zip/
fi


# now do zip backup for code
if [ $limitedbackups == 0 ] && [ $separatezipfolder == 1 ]; then
    "$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/dirs/d1/ "$backupzipfolder"/dirs/d1zip/ --maxbackups 12

    "$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/dirs/d10/ "$backupzipfolder"/dirs/d10zip/
else
    "$pythonpath" "$projectdir"submodules/regbackup/run/copyziplatest.py ~/temp/regbackup/dirs/m1/ "$backupzipfolder"/dirs/m1zip/
fi


# create zips:}}}
