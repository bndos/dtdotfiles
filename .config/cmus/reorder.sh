#!/usr/bin/env sh

# we will use this script to add track number incrementally to all files in a directory using id3v2

nfiles=$(ls -1 | wc -l)

for i in $(seq 1 $nfiles); do
    fileid=$(printf "%02d" $i)
    filename=$(ls -1 | head -n $i | tail -n 1)
    # title is filename without extension '.mp3'
    title=$(echo $filename | awk -F '.mp3' '{print $1}')
    echo "Adding track number $fileid and title $title to $filename"
    id3v2 -a "Chopin" -T $fileid -t "$title" $filename
done
