#!/bin/env bash

source "prefs"

for symbol in $(set | grep '^CS_' | cut -d= -f1)
do
    echo -e "$COL_RESET${!symbol}$symbol"
done
