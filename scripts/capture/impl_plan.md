
# Phase 1:
for this we want to build a script that handles running other commands in a pop-up kitty window
it should more-or-less work alot like: 

```
open /Applications/kitty.app -n --args --single-instance --instance-group popup --title="kitty-popup" /Users/jeff/.config/scripts/building_blocks/read_selected_text
```

the script should accept the command to run as an argument

# Phase 2:
we want to modify the OSX app at capture/CaptureForInbox to call the script insert_into_obsidian_heading, in a pop-up kitty window

