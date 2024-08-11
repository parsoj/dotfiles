function list_workspace_directories
    set workspace_dir (print_workspace_root)

    if test $status -ne 0
        echo "Workspace root not found"
        return 1
    end

    # Use ripgrep to list all directories under the workspace root
    find "$workspace_dir" -type d -not -path "*/.git*"
end
