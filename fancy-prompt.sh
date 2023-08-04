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
        if [[ "$git_status_ahead" -ne "0" ]]
        then 
            echo -n "${git_status_ahead}<"
        fi
        echo -n "${git_status_branch}"
        if [[ "$git_status_behind" -ne "0" ]]
        then 
            echo -n ">${git_status_behind}"
        fi
        echo -n ")"

    }

    function __recurse
    {
        local dir
        local b
        local d
        local sep
        sep=/

        if [[ $# -eq 0 ]]
        then
            # base case: current dir
            dir="$PWD"
        else
            # recursive case: given the path
            dir="$1"
        fi

        if [[ "X$dir" == "X$HOME" ]]
        then
            # while recursing, reimplement the ~ convention
            d=
            b=\~
            sep=
        else
            # work out my name and the path I want to recurse on
            d=$(dirname $dir)
            b=$(basename $dir)
        fi    

        if [[ "X$d" != "X/" && "X$d" != "X" ]]
        then
            # Depth-first recursion
            __recurse $d
        fi    

        # Now draw myself to stdout
        echo -n ${CS_PLAIN}${sep}
        
        if [ -w "$dir" ]
        then
            echo -n "$CS_DIR_RW"
        else    
            echo -n "$CS_DIR_RO"
        fi
        echo -n $b
        if [ -e "$dir/.git" ]
        then  
            __git_info
        fi
        # At the top level, insert a newline
        if [[ $# -eq 0 ]]
        then
            echo
        fi
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

        PS1=$(__recurse)$'${COL_FG_BASE0}\n$ '
    }

    PROMPT_COMMAND=set_prompt_string
}

# Skip if not interactive shell
[[ $- == *i* ]] || return
__set_prompt_command
unset __set_prompt_command
