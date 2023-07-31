#!/bin/bash

# work in progress: can I recurse up the folder tree to the root?  This would allow me to put
# git information at all levels having .git names in; and also to mark writeable folders within 
# read-only folders, etc.

# This works.  It could be the core of the PROMPT_COMMAND, calling out depending on the properties 
# of the current folder to the various additional elements 
function recurse
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
        recurse $d
    fi    

    # Now draw myself to stdout
    if [ -w "$dir" ]
    then
        echo -n ${sep}W
    else    
        echo -n ${sep}R
    fi
    echo -n $b
    if [ -e "$dir/.git" ]
    then  
        echo -n "(G)"
    fi
    
    # At the top level, insert a newline
    if [[ $# -eq 0 ]]
    then
        echo
    fi
}