function list_workspace_files
    set workspace_dir (print_workspace_root)

    if test $status -ne 0
        echo "Workspace root not found"
        return 1
    end

    # Run ripgrep on the workspace root directory
    rg --files $workspace_dir
end
