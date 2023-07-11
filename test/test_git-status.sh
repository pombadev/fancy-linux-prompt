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

source bash_test_framework.fns

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
test "$git_status_branch" = "(0e09ee1)" && test_pass "detached branch Ok" || test_fail "got $git_status_branch"
test_end

# Dirty Worktree ##################################################
test_start "clean repo"
get_flags_for_config clean
$git_status_added_disk && test_fail "detected added file"
$git_status_modified_disk && test_fail "detected modified file"
$git_status_deleted_disk && test_fail "detected deleted file"
$git_status_added_index && test_fail "detected added in index"
$git_status_modified_index && test_fail "detected modified in index"
$git_status_deleted_index && test_fail "detected deleted in index"
test_pass
test_end

test_start "untracked on disk"
get_flags_for_config untracked
$git_status_added_disk && test_pass "detected added file"
$git_status_modified_disk && test_fail "detected modified file"
$git_status_deleted_disk && test_fail "detected deleted file"
$git_status_added_index && test_fail "detected added in index"
$git_status_modified_index && test_fail "detected modified in index"
$git_status_deleted_index && test_fail "detected deleted in index"
test_end

test_start "modified on disk"
get_flags_for_config modified-disk
$git_status_added_disk && test_fail "detected added file"
$git_status_modified_disk && test_pass "detected modified file"
$git_status_deleted_disk && test_fail "detected deleted file"
$git_status_added_index && test_fail "detected added in index"
$git_status_modified_index && test_fail "detected modified in index"
$git_status_deleted_index && test_fail "detected deleted in index"
test_end

test_start "deleted on disk"
get_flags_for_config deleted-disk
$git_status_added_disk && test_fail "detected added file"
$git_status_modified_disk && test_fail "detected modified file"
$git_status_deleted_disk && test_pass "detected deleted file"
$git_status_added_index && test_fail "detected added in index"
$git_status_modified_index && test_fail "detected modified in index"
$git_status_deleted_index && test_fail "detected deleted in index"
test_end

# Dirty Index
test_start "added in index"
get_flags_for_config added
$git_status_added_disk && test_fail "detected added file"
$git_status_modified_disk && test_fail "detected modified file"
$git_status_deleted_disk && test_fail "detected deleted file"
$git_status_added_index && test_pass "detected added in index"
$git_status_modified_index && test_fail "detected modified in index"
$git_status_deleted_index && test_fail "detected deleted in index"
test_end

test_start "modified in index"
get_flags_for_config added
$git_status_added_disk && test_fail "detected added file"
$git_status_modified_disk && test_fail "detected modified file"
$git_status_deleted_disk && test_fail "detected deleted file"
$git_status_added_index && test_pass "detected added in index"
$git_status_modified_index && test_pass "detected modified in index"
$git_status_deleted_index && test_fail "detected deleted in index"
test_end

test_start "deleted in index"
get_flags_for_config deleted-index
$git_status_added_disk && test_fail "detected added file"
$git_status_modified_disk && test_fail "detected modified file"
$git_status_deleted_disk && test_fail "detected deleted file"
$git_status_added_index && test_fail "detected added in index"
$git_status_modified_index && test_fail "detected modified in index"
$git_status_deleted_index && test_pass "detected deleted in index"
test_end

test_start "ahead"
get_flags_for_config ahead
[[ $git_status_ahead == "1" ]] || test_fail "ahead should be 1"
[[ $git_status_behind == "0" ]] || test_fail "behind should have been zero"
test_pass 
test_end

test_start "behind"
get_flags_for_config behind
[[ $git_status_ahead == "0" ]] || test_fail "ahead should be 0; got $git_status_ahead"
[[ $git_status_behind == "1" ]] || test_fail "behind should be 1; got $git_status_behind"
test_pass 
test_end

test_summary 
