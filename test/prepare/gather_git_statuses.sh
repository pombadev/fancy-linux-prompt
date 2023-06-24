#/bin/env bash

echo "info: expect a fatal because one folder is not a valid repo (from $0)"
for folder in $(ls -d t-*)
do 
    (
        cd $folder
        git status --porcelain=2 --branch
    ) > out/$folder.status.txt
done
echo "info: done (from $0)"

