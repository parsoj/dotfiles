function tmux_workspace_create
    read -P "Name: " name
    or return 1
    test -n "$name"
    or return 1
    tmux new-window -n $name "fish -ic \"workspace_create $name; exec fish\""
end
