function tmux_open_workspace
    set ws (workspace_list | fzf --reverse)
    and tmux new-window -n (basename $ws) -c $ws
end
