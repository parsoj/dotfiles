function _list_subfolders_in_ws_dirs_recursive
    set -l current_depth $argv[1]
    set -l current_dir $argv[2]
    set -l MAX_SEARCH_DEPTH 6
    set -l subfolders

    # Check if current depth exceeds the max depth
    if test $current_depth -ge $MAX_SEARCH_DEPTH
        return
    end

    # List directories in the current directory
    set subfolders (find $current_dir -mindepth 1 -maxdepth 1 -type d)

    # Filter out directories containing a .workspace file
    set -l filtered_subfolders
    for dir in $subfolders
        if not test -e "$dir/.workspace.json"
            set filtered_subfolders $filtered_subfolders $dir
        end
    end

    # Recursively call the function for each filtered directory
    for dir in $filtered_subfolders
        set -l sub_subfolders (_list_subfolders_in_ws_dirs_recursive (math $current_depth + 1) $dir)
        set subfolders $subfolders $sub_subfolders
    end

    echo $filtered_subfolders
end

function list_subfolders_in_ws_dirs
    set -l all_subfolders
    for dir in $WS_DIRS
        set -l subfolders (_list_subfolders_in_ws_dirs_recursive 0 $dir)
        set all_subfolders $all_subfolders $subfolders
    end
    echo $all_subfolders
end
