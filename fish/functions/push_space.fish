function push_space --description "Create a new yabai space and focus it"
    yabai -m space --create

    set last_space_index (yabai -m query --spaces --display | jq '.[-1].index')

    yabai -m space --focus $last_space_index
end
