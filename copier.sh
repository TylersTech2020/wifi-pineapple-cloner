#!/bin/bash
# by DSR! from https://github.com/xchwarze/wifi-pineapple-cloner

FILE_LIST=nano.filelist
FROM_FOLDER=rootfs-nano
TO_FOLDER=files
COUNTER=0

rm -rf "$TO_FOLDER"
mkdir "$TO_FOLDER"

for FILE in $(cat "$FILE_LIST")
do
    let COUNTER++
    
    # fix name chars
    FILE=$(echo $FILE | sed $'s/\r//')

    FOLDER=$(dirname $FILE)
    mkdir -p "$TO_FOLDER$FOLDER"

    # if folder...
    if [ -d "$FROM_FOLDER$FILE" ]; then
        cp -R "$FROM_FOLDER$FILE" "$TO_FOLDER$FILE"
    else
        cp -P "$FROM_FOLDER$FILE" "$TO_FOLDER$FILE"
    fi
done

printf "Files copied: %d\n" $COUNTER
