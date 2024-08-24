function _complete_workspace_directory
    for dir in (list_subfolders_in_ws_dirs)
        echo $dir
    end
end

function create_new_workspace
    # Prompt the user to choose the base directory with Fish's completion
    read -P "Select or autocomplete base directory: " base_dir

    # Check if no base directory was selected
    if test -z "$base_dir"
        echo "No base directory selected. Exiting."
        return
    end

    # Prompt the user to type out the remainder of the path
    set -l new_dir
    read -p "Enter the new directory path (relative to $base_dir): " new_dir

    # Combine the base directory with the new directory path
    set -l full_path "$base_dir/$new_dir"

    # Create the new directory
    mkdir -p $full_path

    # Create a .workspace file in the new directory
    touch "$full_path/.workspace"

    # Confirm the directory was created
    echo "Created new workspace directory: $full_path"
end


complete -c create_new_workspace -e # Unregister existing completion

# Register the completion function outside of create_new_workspace
complete -c create_new_workspace -a (list_subfolders_in_ws_dirs)
