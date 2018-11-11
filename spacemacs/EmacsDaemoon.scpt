
-- compile into a mac app with "osacompile -o MyScript.app MyScript.scpt"

property daemonCommand : "/Applications/Emacs.app/Contents/MacOS/Emacs --daemon"

tell application "Terminal"
		do shell script daemonCommand
end tell





