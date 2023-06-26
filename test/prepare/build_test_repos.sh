#!/bin/env bash
#
# This script to be run outside the git repo (e.g. the docker container, via Make)
#
set -u
set -e
set -x

if git status --porcelain=2 >/dev/null 
then
    echo >&2 "Don't run this inside a git repo, it won't work"
    exit 1
fi

# Set up a bunch of git repos for testing the prompt string

function clone-and-enter {
    git clone remote-repo.git "$1"
    cd "$1"
}

mkdir ~/t-norepo

(
    mkdir ~/remote-repo.git
    cd ~/remote-repo.git
    git init --bare .
)

(
    clone-and-enter t-behind
    echo content>file
    git add file
    git commit -am 'first commit'
    git push
)

(
    clone-and-enter t-clean
    echo 'more content' >> file
    git add file
    git commit -am 'second commit'
    git push
)

(
    clone-and-enter t-ahead
    echo 'yet more content' >> file
    git add file
    git commit -am 'second commit'
)

(
    clone-and-enter t-untracked
    touch file2
)

(
    clone-and-enter t-added
    touch file2
    git add file2
)

(
    clone-and-enter t-added2
    touch file2
    git add file2
    touch file3
    git add file3
)

(
    clone-and-enter t-modified-disk
    echo 'modified' >> file
)

(
    clone-and-enter t-modified-index
    echo 'modified' >> file
    git add file
)

( 
    clone-and-enter t-deleted-disk
    rm file
)

(
    clone-and-enter t-deleted-index
    git rm file
)


(
    clone-and-enter t-switch-branch
    git checkout -b feature-branch
)


(
    clone-and-enter t-headless
    git checkout HEAD^
)
