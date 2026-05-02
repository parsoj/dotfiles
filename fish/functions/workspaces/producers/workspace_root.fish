function workspace_root
    set -l current_path (pwd)
    set -l home_path ~

    # Loop until we hit / or ~/
    while test "$current_path" != / -a "$current_path" != "$home_path"
        # Check if .workspace file exists in current directory
        if test -f "$current_path/.workspace.json"
            echo "$current_path"
            return 0
        end

        # Move up one directory
        set current_path (dirname "$current_path")
    end

    # Check the final directory (/ or ~/)
    if test -f "$current_path/.workspace.json"
        echo "$current_path"
        return 0
    end

    # If we got here, we didn't find a .workspace file
    echo "not in a workspace" >&2
    return 1
end
