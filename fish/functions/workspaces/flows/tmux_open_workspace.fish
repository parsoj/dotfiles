function tmux_open_workspace
    set -l ws (workspace_list | fzf --reverse)
    test -n "$ws"; and tmux_window_create_in $ws
end
