#!/usr/bin/env bash

__set_prompt_command() {

    source git-status.fns

    __git_info() {
        # no .git directory
    	[ -d .git ] || return

        local aheadN
        local behindN
        local branch
        local marks
        local stats

        # get current branch name or short SHA1 hash for detached head
        branch="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return  # git branch not found

        # how many commits local branch is ahead/behind of remote?
        stats="$(git status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
        aheadN="$(echo "$stats" | grep -o 'ahead \d\+' | grep -o '\d\+')"
        behindN="$(echo "$stats" | grep -o 'behind \d\+' | grep -o '\d\+')"
        [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
        [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"

        # print the git branch segment without a trailing newline
        # branch is modified?
        if [ -n "$(git status --porcelain)" ]; then
            printf "%s" "${BG_COLOR8}$RESET$BG_COLOR8 $branch$marks $FG_COLOR9"
        else
            printf "%s" "${BG_BLUE}$RESET$BG_BLUE $branch$marks $RESET$FG_BLUE"
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

        PS1="$CS_DIR_RW"
        PS1+="\\w"
        PS1+="$RESET${CS_GIT_OK}"
        PS1+="$(__git_info)"
        PS1+="$RESET"
        PS1+="$BG_EXIT$CS_DIR_RW ${PS_SYMBOL} ${RESET}${FG_EXIT}${RESET} "
    }

    PROMPT_COMMAND=set_prompt_string
}
# Skip if not interactive shell
[[ $- == *i* ]] || return
__set_prompt_command
unset __set_prompt_command
