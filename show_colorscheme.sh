#!/bin/env bash
#
# Pass in a colorscheme (see the color-schemes folder) and this program will dump
# the available colors, rendered in those colors, so that you can more easily choose
# what to put in your preferences file.
#
# EXAMPLE
#
#  ./show_colorscheme.sh solarized
#

source "color-schemes/$1.sh" # pull in the named scheme

for bgsymbol in $(set | grep '^COL_BG_' | cut -d= -f1)
do
    for fgsymbol in $(set | grep '^COL_FG_' | cut -d= -f1)
    do
            echo -e "$COL_RESET${!bgsymbol}${!fgsymbol}${x}$bgsymbol$fgsymbol${x} "
    done
done
