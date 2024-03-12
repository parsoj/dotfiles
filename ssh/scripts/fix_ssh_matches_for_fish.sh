#!/bin/bash

# this script fixes all the match exec lines in the ~/.ssh/config file
# (created by some of marc's DBL scripts)
# to work with fish shell

sed -i.bak -E 's/Match exec "grepcidr -x -e ([0-9\.,\/]+) \&>\/dev\/null <<< \%h"/Match exec "echo \%h | grepcidr -x -e \1 >\/dev\/null 2>\&1"/g' ~/.ssh/config
