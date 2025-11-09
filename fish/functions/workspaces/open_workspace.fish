function open_workspace
    set workspace_path (list_workspaces | fzf)

    # Check if fzf was exited without a selection
    if test -z "$workspace_path"
        echo "No workspace selected. Aborting."
        return 1
    end

    zed "$workspace_path"
end
