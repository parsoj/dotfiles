function cd_workspace_root
    set workspace_dir (print_workspace_root)

    if test $status -ne 0
        echo "Workspace root not found"
        return 1
    end

    cd $workspace_dir
end
