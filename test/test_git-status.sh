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

# Dirty Worktree ##################################################
test_start "clean repo"
get_flags_for_config clean
$git_status_added_disk && test_fail "detected added file"
$git_status_modified_disk && test_fail "detected modified file"
$git_status_deleted_disk && test_fail "detected deleted file"
test_pass
test_end

test_start "untracked on disk"
get_flags_for_config untracked
$git_status_added_disk && test_pass "detected added file"
$git_status_modified_disk && test_fail "detected modified file"
$git_status_deleted_disk && test_fail "detected deleted file"
test_end

test_start "modified on disk"
get_flags_for_config modified-disk
$git_status_added_disk && test_fail "detected added file"
$git_status_modified_disk && test_pass "detected modified file"
$git_status_deleted_disk && test_fail "detected deleted file"
test_end

test_start "deleted on disk"
get_flags_for_config deleted-disk
$git_status_added_disk && test_fail "detected added file"
$git_status_modified_disk && test_fail "detected modified file"
$git_status_deleted_disk && test_pass "detected deleted file"
test_end


test_summary 
