#!/bin/env bash

source "color-schemes/$1.sh" # pull in the named scheme

for bgsymbol in $(set | grep '^COL_BG_' | cut -d= -f1)
do
    for fgsymbol in $(set | grep '^COL_FG_' | cut -d= -f1)
    do
            echo -e "$COL_RESET${!bgsymbol}${!fgsymbol}${x}$bgsymbol$fgsymbol${x} "
    done
done
