function list_workspace_containing_directories
    set -l result
    for dir in (string split ' ' $WS_DIRS)
        __list_workspace_containing_directories_helper $dir result 0
    end
end

function __list_workspace_containing_directories_helper
    set -l current_dir $argv[1]
    set -l result_array_name $argv[2]
    set -l current_depth $argv[3]

    # Check if we've reached the maximum depth
    if test $current_depth -ge 12
        return
    end

    # Check if the current directory contains a .workspace file
    if test -e "$current_dir/.workspace"
        return
    end

    if test -e "$current_dir/.workspace.json"
        return
    end

    # Append the current directory to the result array
    set -a $result_array_name $current_dir

    echo $current_dir

    # Recurse into child directories
    for child_dir in (find "$current_dir" -maxdepth 1 -type d -not -name '.*')
        if test "$child_dir" != "$current_dir"
            __list_workspace_containing_directories_helper $child_dir $result_array_name (math $current_depth + 1)
        end
    end
end
