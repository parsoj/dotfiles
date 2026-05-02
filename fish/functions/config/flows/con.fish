function con --description "pick a file under ~/.config and open it in nvim"
    set -l file (config_list | fzf --prompt="~/.config> ")
    test -n "$file"; and config_open $file
end
