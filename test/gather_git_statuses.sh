#/bin/env bash

for folder in t-*
do 
    (
        cd $folder
        git status --porcelain=2 --branch
    ) > $folder.status.txt
done

