#!/bin/bash

# query current focused desktop
current_desktop_id=$(chunkc tiling::query --desktop id)

# clean up all windows on desktop
for window_id in $(chunkc tiling::query --windows-for-desktop $current_desktop_id | awk -F ',' '{print $1}')
do
    chunkc tiling::window --focus $window_id
    chunkc tiling::window --close
done

# destroy current desktop
chunkc tiling::desktop --annihilate
