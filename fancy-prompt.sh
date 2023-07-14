#!/usr/bin/env bash

__set_prompt_command() {

    source git-status.fns
    source prefs

    __git_info() {
        # no .git directory
        git_status_branch < <(git status --porcelain=2 --branch)
        if $git_status_added_index || $git_status_modified_index || $git_status_deleted_index 
        then
            echo -n $CS_GIT_IDX
        else
            if $git_status_added_disk || $git_status_modified_disk || $git_status_deleted_disk
            then
                echo -n $CS_GIT_MOD
            else
                echo -n $CS_GIT_OK
            fi
        fi
        echo -n "("
        echo -n "${git_status_branch}"
        echo ")"

    }

    set_prompt_string() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly.
        if [ "$?" -eq 0 ]; then
            local BG_EXIT="$BG_GREEN"
            local FG_EXIT="$FG_GREEN"
        else
            local BG_EXIT="$BG_RED"
            local FG_EXIT="$FG_RED"
        fi

        PS1="$CS_DIR_RW"
        PS1+="\\w"
        PS1+="$RESET"
        PS1+="$(__git_info)"
        PS1+="$RESET"
        PS1+=" ${COL_FG_BASE0}\\$ "
    }

    PROMPT_COMMAND=set_prompt_string
}
# Skip if not interactive shell
[[ $- == *i* ]] || return
__set_prompt_command
unset __set_prompt_command
