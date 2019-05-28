tell application "System Events"
     tell application "Emacs" to activate
     delay .3
     key code 53 #escape
     key code 49 #SPC
     key code 49 #SPC
     key code 2 #d
     key code 14 #e
     key code 37 #l
     key code 14 #e
     key code 17 #t
     key code 14 #e
     key code 27 #-
     key code 3 #f
     key code 15 #r
     key code 0 #a
     key code 46 #m
     key code 14 #e
     key code 36 # return
end tell
