function open_cwd_child_file
    set selected_file (list_cwd_child_files | fzf)

    if test -z "$selected_file"
        echo "No file selected"
        return 1
    end

    nvim "$selected_file"
end
