#!/usr/bin/env bash
# function to move file to a trash folder

# two copies made in trash folder:
# 1. trash/file1
# 2. trash/trash_old_versions/file1_yyyymmdd_hhmmss

# idea of two versions:
# can easily access deleted stuff without having to rename
# but also don't delete permanently if I trash a file with the same basename twice

# if file1 is called trash_old_versions, returns error
# can also move multiple files at the same time

set -e

trashfolder=~/trash

if [ ! -d "$trashfolder" ]; then
    mkdir -p "$trashfolder"
fi
if [ ! -d "$trashfolder"/trash_old_versions ]; then
    mkdir "$trashfolder/trash_old_versions"
fi

dateext=$(date '+%Y%m%d_%H%M%S')

for filename in "$@"; do
    # get fullfilename for the file
    fullfilename="$(cd "$(dirname "$filename")"; pwd -P)/$(basename "$filename")"

    if [ ! -e "$fullfilename" ]; then
        echo "$fullfilename does not exist"
        exit 1
    fi

    # get basename
    basefilename="${filename##*/}"

    if [ "$basefilename" == "trash_old_versions" ]; then
        echo "cannot back up a file with basename trash_old_versions"
        exit 1
    fi

    backupdate="$trashfolder"/trash_old_versions/"$basefilename"_"$dateext"

    # verify backup in trash/trash_old_versions/ does not exist already
    if [ -e "$backupdate" ]; then
        echo "$backupdate already exists"
        exit 1
    fi

    # copy across file to trash/trash_old_versions
    cp -r "$fullfilename" "$backupdate"

    # delete trashfolder version if exists - "mv -f" doesn't always work
    if [ -e "$trashfolder"/"$basefilename" ]; then
        rm -rf "$trashfolder"/"$basefilename"
    fi
    # mv across file to trash
    mv "$fullfilename" "$trashfolder"
    
done
