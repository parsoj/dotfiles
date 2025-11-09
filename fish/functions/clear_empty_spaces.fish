function clear_empty_spaces --description "Remove empty yabai spaces that have no windows"
    # Query all spaces and windows
    set spaces_json (yabai -m query --spaces 2>/dev/null)
    or begin
        echo "Error: Failed to query yabai spaces" >&2
        return 1
    end

    set windows_json (yabai -m query --windows 2>/dev/null)
    or begin
        echo "Error: Failed to query yabai windows" >&2
        return 1
    end

    # Get total space count
    set spaces_count (echo $spaces_json | jq 'length')
    echo "Total spaces: $spaces_count"

    # Get list of spaces that have windows
    set occupied_spaces (echo $windows_json | jq -r '.[].space' | sort -u)

    # Destroy spaces in reverse order (high to low) including space 1
    for i in (seq $spaces_count -1 1)
        if not contains $i $occupied_spaces
            echo "Deleting space: $i"
            yabai -m space --destroy $i
        end
    end
end
