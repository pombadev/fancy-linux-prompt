#!/usr/bin/env bash

__set_prompt_command() {

    source git-status.fns
    source prefs

    __git_info() {
        # no .git directory
        git_status_branch < <(git status --porcelain=2 --branch)
        if $git_status_added_index || $git_status_modified_index || $git_status_deleted_index 
        then
            git_status_color=$CS_GIT_IDX
        else
            if $git_status_added_disk || $git_status_modified_disk || $git_status_deleted_disk
            then
                git_status_color=$CS_GIT_MOD
            else
                git_status_color=$CS_GIT_OK
            fi
        fi
        echo -n "${git_status_color}("
        if [[ "$git_status_behind" -ne "0" ]]
        then 
            echo -n "${CS_GIT_BEHIND}<${git_status_behind}"
        fi
        echo -n "${git_status_color}${git_status_branch}"
        if [[ "$git_status_ahead" -ne "0" 
        ]]
        then 
            echo -n "${CS_GIT_AHEAD}>${git_status_ahead}"
        fi
        echo -n "${git_status_color})"

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
        return_status=$?
        if [ "${return_status}" -eq "0" ]; then
            BG_EXIT="$COL_BG_GREEN"
            FG_EXIT="$COL_FG_GREEN"
            status_string=""
        else
            BG_EXIT="$COL_BG_RED"
            FG_EXIT="$COL_FG_RED"
            status_string="💣 ${return_status}"
        fi


        PS1=$(__recurse)$' ${status_string}${COL_FG_BASE0}\n\x01${FG_EXIT}\x02\$\x01${COL_RESET}\x02 '
    }

    PROMPT_COMMAND=set_prompt_string
}

# Skip if not interactive shell
[[ $- == *i* ]] || return
__set_prompt_command
unset __set_prompt_command
