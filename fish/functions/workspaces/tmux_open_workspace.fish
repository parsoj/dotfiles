function tmux_open_workspace
    set ws (list_workspaces | fzf --reverse)
    and tmux new-window -n (basename $ws) -c $ws
end
