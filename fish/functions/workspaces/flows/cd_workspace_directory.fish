function cd_workspace_directory
    set selected_dir (list_workspace_directories | fzf)

    if test -z "$selected_dir"
        echo "No directory selected"
        return 1
    end

    cd "$selected_dir"
end
