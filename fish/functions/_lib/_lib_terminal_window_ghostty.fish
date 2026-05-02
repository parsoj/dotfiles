# Ghostty adapter for _lib_terminal_window.
#
# On macOS, ghostty can't be launched directly from the CLI; use `open -na`
# with --args to forward Ghostty's `-e <command>` flag through to the app.
#
# We wrap the user's command in `fish -c '<cmd>'` so that fish function names
# (autoloaded actions like config_open, nvim_open, etc.) resolve correctly.
# Without the fish wrap, Ghostty's -e would try to execvp the literal string,
# which fails for fish functions since they aren't on PATH.
function _lib_terminal_window_ghostty --description "[internal] _lib_terminal_window adapter: Ghostty"
    set -l user_cmd (string join ' ' (string escape -- $argv))
    open -na Ghostty.app --args -e fish -c $user_cmd
end
