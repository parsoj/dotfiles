# @raycast              yes
# @raycast-title        Open Config File
# @raycast-description  Pick a file under ~/.config and open it
# @raycast-producer     config_list
# @raycast-action       config_open
# @raycast-display      path
function con --description "pick a file under ~/.config and open it in nvim"
    set -l file (config_list | fzf --prompt="~/.config> ")
    test -n "$file"; and config_open $file
end
