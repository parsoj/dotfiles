# @inputs cmd:string [args...]
# Interface for "open a new terminal window running this command".
# Dispatches to _lib_terminal_window_<adapter>, where adapter is the value of
# $FISH_TERMINAL (default: ghostty). To add a new terminal, drop a sibling
# function _lib_terminal_window_<name> that accepts the same argv shape.
function _lib_terminal_window --description "[internal] open a new terminal window running argv as a command"
    set -l adapter (set -q FISH_TERMINAL; and echo $FISH_TERMINAL; or echo ghostty)
    set -l fn _lib_terminal_window_$adapter
    if not functions -q $fn
        echo "_lib_terminal_window: no adapter '$adapter' ($fn not defined)" >&2
        return 1
    end
    $fn $argv
end
