#!/bin/bash

chunkc tiling::desktop --create

# get id of desktop just created
DPM=$(/usr/local/bin/chunkc tiling::query --desktops-for-monitor 1 | sed 's/ //g;s/\n//g' | wc -c)
new_desktop_id=$((DPM-1))
echo $new_desktop_id

# move to desktop
chunkc tiling:desktop --focus $new_desktop_id
