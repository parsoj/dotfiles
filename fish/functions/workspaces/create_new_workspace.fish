function create_new_workspace

    set parent_folder (list_workspace_containing_directories | fzf)

    # Check if fzf was exited without a selection
    if test -z "$parent_folder"
        echo "No parent directory selected. Aborting."
        return 1
    end

    read -P "New workspace folder:
     $parent_folder/" new_sub_directory

    # Check if the user didn't provide a subdirectory name
    if test -z "$new_sub_directory"
        echo "No subdirectory path provided. Aborting."
        return 1
    end

    set full_path "$parent_folder/$new_sub_directory"

    echo "Creating new workspace at: $full_path"
    mkdir -p "$full_path"

    touch "$full_path/.workspace.json"
    echo "Created .workspace.json file in $full_path"

    cd "$full_path"
    echo "Changed directory to: $full_path"
end
