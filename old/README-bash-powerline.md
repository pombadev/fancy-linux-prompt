# bash-powerline-ng

Powerline for Bash in pure Bash script.
Forked from https://github.com/riobard/bash-powerline


![bash-powerline-ng](https://raw.github.com/z4ziggy/bash-powerline-ng/master/screenshots/terminal1.png)

## Features

* Git branch: display branch symbol and current git branch name, or short SHA1 hash when the head is detached
* Git branch: foreground color reflects uncommited changes
* Git branch: display "⇡" or "⇣" symbols plus the difference in the number of commits when the current branch is ahead or behind of remote (see screenshot)
* ~~Platform-dependent prompt symbol for OS X and Linux (see screenshots)~~
* Colored error for the previously failed command
* Folder colors reflects write permissions for user
* Color differentiation for user/root
* Disk/Home/Network symbols for path visualization
* Fast execution (no noticable delay)


## Installation

Download the Bash script

    wget -O ~/.bash-powerline-ng.sh https://raw.github.com/z4ziggy/bash-powerline-ng/master/bash-powerline-ng.sh

And source it in your `.bashrc`

    source ~/.bash-powerline-ng.sh

## Why

Because [bash-powerline](https://github.com/riobard/bash-powerline) is great, 
but I wanted it to look nicer.

For everything else, please check the original [bash-powerline](https://github.com/riobard/bash-powerline) project

