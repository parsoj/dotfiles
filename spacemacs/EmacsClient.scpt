
-- compile into a mac app with "osacompile -o MyScript.app MyScript.scpt"

property clientCommand : "cd && /Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n -e '(progn (eshell) (spacemacs/toggle-maximize-buffer) (evil-end-of-line) (evil-insert 1))'"


tell application "Terminal"
  do shell script clientCommand
end tell

tell application "Emacs" to activate




