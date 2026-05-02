function workspace_file_list
    set workspace_dir (workspace_root)

    if test $status -ne 0
        echo "Workspace root not found"
        return 1
    end

    # Run ripgrep on the workspace root directory
    rg --files $workspace_dir
end
