#!/bin/bash

# query current focused desktop
current_desktop_id=$(chunkc tiling::query --desktop id)
prev_desktop_id=$(chunkc get _last_active_desktop)

# clean up all windows on desktop
window_query=$(chunkc tiling::query --windows-for-desktop $current_desktop_id | sed 's/ //g')
IFS=','
while read -r window_id window_title window_subtitle
do
    if [ $window_title == "Emacs" ]
    then
      osascript $HOME/.config/osx/scripts/close_emacs_window.scpt
    else
      chunkc tiling::window --focus $window_id
      chunkc tiling::window --close
    fi
done <<< "$window_query"


# destroy current desktop
chunkc tiling::desktop --annihilate

# move to prev desktop
chunkc tiling:desktop --focus $prev_desktop_id
