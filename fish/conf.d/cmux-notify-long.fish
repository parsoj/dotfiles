# Notify via cmux when a long-running foreground command finishes.
#
# Performance contract: the fast path (every prompt) is ONE integer compare
# using fish builtins only — no forks, no subshells, no string ops. Everything
# else runs only after a command that already took >= the failure threshold,
# and the `cmux notify` call itself is backgrounded so it never delays the
# prompt.

if status is-interactive; and set -q CMUX_SURFACE_ID; and command -q cmux
    # Thresholds in ms. Failures are more interesting, so they notify sooner.
    set -q cmux_notify_ok_ms; or set -g cmux_notify_ok_ms 30000
    set -q cmux_notify_fail_ms; or set -g cmux_notify_fail_ms 10000

    # First word of the command line; interactive programs where wall-clock
    # time is meaningless. Edit freely.
    set -g __cmux_notify_blocklist \
        vim nvim vi emacs nano hx kak \
        less more man bat \
        ssh mosh et tmux zellij \
        fzf yazi br broot ranger nnn \
        claude \
        python python3 ipython node irb pry psql mysql sqlite3 \
        top htop btop k9s lazygit tig watch

    function __cmux_notify_long --on-event fish_postexec
        set -l st $status
        # ---- fast path: builtins only, return ASAP ----
        set -q CMD_DURATION; or return
        test $CMD_DURATION -lt $cmux_notify_fail_ms; and return
        if test $st -eq 0; and test $CMD_DURATION -lt $cmux_notify_ok_ms
            return
        end
        # ---- slow path: only reached after a 10s+ command ----
        set -l first (string split -m1 -f1 ' ' -- (string trim -- $argv[1]))
        contains -- $first $__cmux_notify_blocklist; and return

        set -l secs (math -s0 "$CMD_DURATION / 1000")
        set -l took "$secs"s
        if test $secs -ge 60
            set took (math -s0 "$secs / 60")m(math "$secs % 60")s
        end
        set -l icon ✅
        set -l detail "finished in $took"
        if test $st -ne 0
            set icon ❌
            set detail "failed (exit $st) after $took"
        end
        command cmux notify \
            --title "$icon $first $detail" \
            --body (string sub -l 200 -- $argv[1]) \
            --surface $CMUX_SURFACE_ID >/dev/null 2>&1 &
        disown 2>/dev/null
    end
end
