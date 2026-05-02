function go_to_workspace
    set workspace_path (workspace_list | fzf)

    # Check if fzf was exited without a selection
    if test -z "$workspace_path"
        echo "No workspace selected. Aborting."
        return 1
    end

    cd "$workspace_path"
end
