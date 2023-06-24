#!/bin/bash
set -u
set -e
set -o pipefail
# work in progress to test the git status bash function

# This function is the system under test (SUT)
function git_status_branch {
    readarray lines
    for line in "${lines[@]}"
    do
        if grep -q "^# branch.head" <<< $line 
        then
            git_status_branch=$(sed 's/.*\.head //'<<<$line)
        fi
    done 
}
# end SUT

function get_flags_for_config {
    local file="git-status-output/t-$1.status.txt"
    echo "$file"
    git_status_branch < "$file"
}
# Branch name

get_flags_for_config clean
echo $git_status_branch

get_flags_for_config switch-branch
echo $git_status_branch

get_flags_for_config headless
echo $git_status_branch

