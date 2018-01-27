#!/usr/bin/env bash

__powerline() {
    # Unicode symbols
    readonly GIT_BRANCH_CHANGED_SYMBOL='+'
    readonly GIT_NEED_PULL_SYMBOL='⇣'
    readonly GIT_NEED_PUSH_SYMBOL='⇡'
    readonly PS_SYMBOL='🐧'

    # Solarized colorscheme
    readonly BG_BASE00="\\[$(tput setab 11)\\]"
    readonly BG_BASE01="\\[$(tput setab 10)\\]"
    readonly BG_BASE02="\\[$(tput setab 0)\\]"
    readonly BG_BASE03="\\[$(tput setab 8)\\]"
    readonly BG_BASE0="\\[$(tput setab 12)\\]"
    readonly BG_BASE1="\\[$(tput setab 14)\\]"
    readonly BG_BASE2="\\[$(tput setab 7)\\]"
    readonly BG_BASE3="\\[$(tput setab 15)\\]"
    readonly BG_BLUE="\\[$(tput setab 4)\\]"
    readonly BG_COLOR1="\\[\\e[48;5;240m\\]"
    readonly BG_COLOR2="\\[\\e[48;5;238m\\]"
    readonly BG_COLOR3="\\[\\e[48;5;238m\\]"
    readonly BG_COLOR4="\\[\\e[48;5;31m\\]"
    readonly BG_COLOR5="\\[\\e[48;5;31m\\]"
    readonly BG_COLOR6="\\[\\e[48;5;237m\\]"
    readonly BG_COLOR7="\\[\\e[48;5;237m\\]"
    readonly BG_COLOR8="\\[\\e[48;5;161m\\]"
    readonly BG_COLOR9="\\[\\e[48;5;161m\\]"
    readonly BG_CYAN="\\[$(tput setab 6)\\]"
    readonly BG_GREEN="\\[$(tput setab 2)\\]"
    readonly BG_MAGENTA="\\[$(tput setab 5)\\]"
    readonly BG_ORANGE="\\[$(tput setab 9)\\]"
    readonly BG_RED="\\[$(tput setab 1)\\]"
    readonly BG_VIOLET="\\[$(tput setab 13)\\]"
    readonly BG_YELLOW="\\[$(tput setab 3)\\]"
    readonly BOLD="\\[$(tput bold)\\]"
    readonly DIM="\\[$(tput dim)\\]"
    readonly FG_BASE00="\\[$(tput setaf 11)\\]"
    readonly FG_BASE01="\\[$(tput setaf 10)\\]"
    readonly FG_BASE02="\\[$(tput setaf 0)\\]"
    readonly FG_BASE03="\\[$(tput setaf 8)\\]"
    readonly FG_BASE0="\\[$(tput setaf 12)\\]"
    readonly FG_BASE1="\\[$(tput setaf 14)\\]"
    readonly FG_BASE2="\\[$(tput setaf 7)\\]"
    readonly FG_BASE3="\\[$(tput setaf 15)\\]"
    readonly FG_BLUE="\\[$(tput setaf 4)\\]"
    readonly FG_COLOR1="\\[\\e[38;5;250m\\]"
    readonly FG_COLOR2="\\[\\e[38;5;240m\\]"
    readonly FG_COLOR3="\\[\\e[38;5;250m\\]"
    readonly FG_COLOR4="\\[\\e[38;5;238m\\]"
    readonly FG_COLOR6="\\[\\e[38;5;31m\\]"
    readonly FG_COLOR7="\\[\\e[38;5;250m\\]"
    readonly FG_COLOR8="\\[\\e[38;5;237m\\]"
    readonly FG_COLOR9="\\[\\e[38;5;161m\\]"
    readonly FG_CYAN="\\[$(tput setaf 6)\\]"
    readonly FG_GREEN="\\[$(tput setaf 2)\\]"
    readonly FG_MAGENTA="\\[$(tput setaf 5)\\]"
    readonly FG_ORANGE="\\[$(tput setaf 9)\\]"
    readonly FG_RED="\\[$(tput setaf 1)\\]"
    readonly FG_VIOLET="\\[$(tput setaf 13)\\]"
    readonly FG_YELLOW="\\[$(tput setaf 3)\\]"
    readonly RESET="\\[$(tput sgr0)\\]"
    readonly REVERSE="\\[$(tput rev)\\]"

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
            printf "%s" "${BG_COLOR8}$RESET$BG_COLOR8 $branch$marks $FG_COLOR9"
        else
            printf "%s" "${BG_BLUE}$RESET$BG_BLUE $branch$marks $RESET$FG_BLUE"
        fi
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly.
        if [ "$?" -eq 0 ]; then
            local BG_EXIT="$BG_GREEN"
            local FG_EXIT="$FG_GREEN"
        else
            local BG_EXIT="$BG_RED"
            local FG_EXIT="$FG_RED"
        fi

        PS1="$FG_COLOR1"
        PS1+="$BG_COLOR5 \\w "
        PS1+="$RESET${FG_COLOR6}"
        PS1+="$(__git_info)"
        PS1+="$BG_EXIT$RESET"
        PS1+="$BG_EXIT$FG_BASE3 ${PS_SYMBOL} ${RESET}${FG_EXIT}${RESET} "
    }

    PROMPT_COMMAND=ps1
}

__powerline
unset __powerline
