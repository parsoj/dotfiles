#!/usr/bin/env bash

if [ "$#" -eq 0 ]; then
    emacsclient -c --frame-parameters='(quote (name . "client-frame"))'
elif [ "$#" -eq 1 ]; then
   emacsclient -c --frame-parameters='(quote (name . "client-frame"))' -e $1
else
    echo "Invalid number of positional arguments passed"
fi
