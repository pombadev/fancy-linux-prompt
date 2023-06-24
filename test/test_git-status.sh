#!/bin/bash
set -u
# work in progress to test the git status bash function

function git_status_flags {
    readarray lines
    for line in "${lines[@]}"
    do
        if grep "^# branch.head" <<< $line 
        then
            git_status_branch=$(sed 's/.*\.head //'<<<$line)
        fi
    done 
}

# Branch name
for file in git-status-output/t-*
do
    echo $file
    git_status_flags < $file
    echo $git_status_branch
done
