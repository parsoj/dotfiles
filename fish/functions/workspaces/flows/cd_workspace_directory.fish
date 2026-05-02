function cd_workspace_directory
    set selected_dir (workspace_dir_list | fzf)

    if test -z "$selected_dir"
        echo "No directory selected"
        return 1
    end

    cd "$selected_dir"
end
