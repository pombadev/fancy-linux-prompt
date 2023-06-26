#!/bin/bash
set -u
set -e
set -o pipefail
# work in progress to test the git status bash function

btf_name=""
# This function is the system under test (SUT)
source ../git-status.fns
# end SUT

function get_flags_for_config {
    local file="git-status-output/t-$1.status.txt"
    test_info "$file"
    git_status_branch < "$file"
}

source bash_test_framework.sh

# Branch name tests
test_start "clean repo"
get_flags_for_config clean
test "$git_status_branch" = "master" && test_pass "master branch Ok"
test_end

test_start "switched repo"
get_flags_for_config switch-branch
test "$git_status_branch" = "feature-branch" && test_pass "feature-branch branch Ok"
test_end

test_start "detached"
get_flags_for_config headless
test "$git_status_branch" = "(detached)" && test_pass "detached branch Ok"
test_end

# Dirty Worktree
test_start "not added"
get_flags_for_config clean
$git_status_added_disk || test_pass "clean repo does not show added file"
$git_status_modified_disk || test_pass "clean repo does not show modified file"
test_end

test_start "added disk"
get_flags_for_config added
$git_status_added_disk && test_pass "detect added file on disk"
$git_status_modified_disk || test_pass "clean repo does not show modified file"
test_end

test_start "added multiple on disk"
get_flags_for_config added2
$git_status_added_disk && test_pass "detect added files on disk"
$git_status_modified_disk || test_pass "clean repo does not show modified file"
test_end

test_start "modified on disk"
get_flags_for_config modified-disk
$git_status_added_disk || test_pass "clean repo does not show added file"
$git_status_modified_disk && test_pass "detect modified files on disk"
test_end


test_summary 
