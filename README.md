# Less fancy linux prompt

A linux prompt inspired by fancy-linux-prompt, but with the emphasis on 
readbility by conformance with the solarized color scheme, and not forcing you to use the font with the chevrons in.

## Design

The folder color-schemes contains bash files that define sets of colors in variables called 

* `COL_FG_*`
* `COL_BG_*`
* `COL_X_*`

There is only one such scheme, solarized.sh.

The file `prefs` maps colors in the scheme to semantic names, `CS_GIT_CLEAN` etc.  This file should be the only place you have to make changes to tune what you see.

## DONE 

* Render the folder and branch into PS1
* Color the branch according to whether it is dirty

## TO-DO

* Color the path according to whether the folder is writable
* Indicators for ahead and behind

## TO-THINK-ABOUT

* If I want to indicate uncommitted changes, there are lots of kinds: new on disk, added in index, changed on disk, changed in index, removed on disk, removed in index... what is needed and how to represent it?

* 
