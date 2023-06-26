#!/bin/bash
set -u
set -e
set -o pipefail
# work in progress to test the git status bash function

btf_name=""
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
    test_info "$file"
    git_status_branch < "$file"
}

source bash_test_framework.sh

test_start "Branch name/clean repo"
get_flags_for_config clean
test "$git_status_branch" = "master" && test_pass "master branch Ok"
test_end

test_start "Branch name/switched repo"
get_flags_for_config switch-branch
test "$git_status_branch" = "feature-branch" && test_pass "feature-branch branch Ok"
test_end

test_start "detached"
get_flags_for_config headless
test "$git_status_branch" = "(detached)" && test_pass "detached branch Ok"
test_end

test_summary
