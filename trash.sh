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

trashfolder=~/temp/trash
oldtrashstem=~/temp/oldtrash
# get date - date runs differently on linux v macbook
if [ "$(uname)" == "Darwin" ]; then
    # macbook
    onemonthago="$(date -v "-1m" +%Y%m)"
else
    # linux
    onemonthago="$(date --date='1 month ago' +%Y%m)"
fi
oldtrashfolder="$oldtrashstem"_"$onemonthago"

# Adjust old trash folder:{{{1
# if oldtrashstem exist as folder then stop
if [ -e "$oldtrashstem" ]; then
    echo "$oldtrashstem already exists. Cannot continue while this exists."
    exit 1
fi

# mv current oldtrashfolder to oldtrashstem while delete old versions of oldtrashfolder
if [ -e "$oldtrashfolder" ]; then
    mv "$oldtrashfolder" "$oldtrashstem"
fi

# delete old versions of oldtrashfolder
rm -rf "$oldtrashstem"_*

# rename oldtrashfolder as the correct name again
if [ -e "$oldtrashstem" ]; then
    mv "$oldtrashstem" "$oldtrashfolder"
fi

# move current trash to oldtrash if oldtrash does not exist
if [ ! -e "$oldtrashfolder" ]; then
    echo 1
    if [ -e "$trashfolder" ]; then
        mv "$trashfolder" "$oldtrashfolder"
    else
        mkdir -p "$oldtrashfolder"
    fi
fi

# Set up Folders:{{{1
if [ ! -d "$trashfolder" ]; then
    mkdir -p "$trashfolder"
fi
if [ ! -d "$trashfolder"/trash_old_versions ]; then
    mkdir -p "$trashfolder/trash_old_versions"
fi

# Move files to trash:{{{1
dateext=$(date '+%Y%m%d_%H%M%S')

for filename in "$@"; do
    # get fullfilename for the file
    fullfilename="$(cd "$(dirname "$filename")"; pwd -P)/$(basename "$filename")"

    if [ ! -e "$fullfilename" ]; then
        echo "$fullfilename does not exist"
        exit 1
    fi

    # get basename
    # basefilename="${filename##*/}" # this didn't work when file ended in "/"
    basefilename="$(basename "$filename")"

    if [ "$basefilename" == "trash_old_versions" ]; then
        echo "cannot back up a file with basename trash_old_versions"
        exit 1
    fi

    backupdate="$trashfolder"/trash_old_versions/"$basefilename"_"$dateext"


    # copy across file to trash/trash_old_versions
    # cp -r "$fullfilename" "$backupdate"

    # delete trashfolder version if exists - "mv -f" doesn't always work
    if [ -e "$trashfolder"/"$basefilename" ]; then
        # need to move across file to old_trash_versions/

        # verify backup in trash/trash_old_versions/ does not exist already
        if [ -e "$backupdate" ]; then
            echo "$backupdate already exists"
            exit 1
        fi

        echo 1234
        echo "$trashfolder"
        echo "$basefilename"

        mv "$trashfolder"/"$basefilename" "$backupdate"
        echo 234
    fi

    # mv across file to trash
    mv "$fullfilename" "$trashfolder"
    
done
