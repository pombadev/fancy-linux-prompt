#/bin/env bash

for folder in $(ls -d t-*)
do 
    (
        cd $folder
        git status --porcelain=2 --branch
    ) > out/$folder.status.txt
done

