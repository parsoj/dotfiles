function clear_empty_spaces --description "Remove empty yabai spaces that have no windows"
    # Query all spaces
    set spaces_json (yabai -m query --spaces 2>/dev/null)
    or begin
        echo "Error: Failed to query yabai spaces" >&2
        return 1
    end

    # Get total space count
    set spaces_count (echo $spaces_json | jq 'length')
    echo "Total spaces: $spaces_count"

    # Get empty space indices in reverse order (high to low)
    set empty_spaces (echo $spaces_json | jq -r '.[] | select(.windows | length == 0) | .index' | sort -rn)

    # Destroy empty spaces
    for space_index in $empty_spaces
        echo "Deleting space at index: $space_index"
        yabai -m space --destroy $space_index 2>&1
    end
end
