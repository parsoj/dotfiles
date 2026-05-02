function create_new_workspace
    set -l no_clipboard false
    set -l args

    for arg in $argv
        if test "$arg" = "--no-clipboard"
            set no_clipboard true
        else
            set -a args $arg
        end
    end

    set -l name (string join "-" $args)

    if test -z "$name"
        read -P "Workspace name: " name
    end

    if test -z "$name"
        echo "No workspace name provided. Aborting."
        return 1
    end

    set -l full_path ~/code/workspaces/$name

    echo "Creating new workspace at: $full_path"
    mkdir -p "$full_path"
    touch "$full_path/.workspace.json"

    cd "$full_path"

    # If clipboard contains a GitHub URL, add that repo to the workspace
    if test "$no_clipboard" = false
        set -l clip (pbpaste | string trim)
        if string match -rq '^(https://github\.com/|git@github\.com:)' "$clip"
            echo "Found GitHub URL in clipboard: $clip"
            add_repo "$clip"
        end
    end

    echo "Ready."
end
