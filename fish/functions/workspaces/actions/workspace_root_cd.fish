function workspace_root_cd
    set workspace_dir (workspace_root)

    if test $status -ne 0
        echo "Workspace root not found"
        return 1
    end

    cd $workspace_dir
end
