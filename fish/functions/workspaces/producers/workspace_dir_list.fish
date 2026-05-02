function workspace_dir_list
    set workspace_dir (workspace_root)

    if test $status -ne 0
        echo "Workspace root not found"
        return 1
    end

    # Use ripgrep to list all directories under the workspace root
    find "$workspace_dir" -type d -not -path "*/.git*"
end
