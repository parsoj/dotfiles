function new_project --description "Create a tmux window + Tennr workspace in one step"
    set -l name (string join "-" $argv)

    if test -z "$name"
        read -P "Project name: " name
    end

    if test -z "$name"
        echo "No project name provided. Aborting."
        return 1
    end

    if not set -q TMUX
        echo "Not in a tmux session. Aborting."
        return 1
    end

    tmux new-window -n $name
    tmux send-keys "workspace_create $name" Enter
end
