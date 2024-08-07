
set -x CONFIG_DIRS "fish:git:kitty:nvim:skhd:ssh:yabai"
set -x CONFIG_ROOT "$HOME/.config"

function cfls
    set -l dirs (string split : $CONFIG_DIRS)
    set -l result

    for dir in $dirs
        set -l full_path "$CONFIG_ROOT/$dir"
        echo $full_path
        if test -d $full_path
            set result $result (find $full_path -type f -maxdepth 5)
        end
    end

    # Remove duplicates and print the result
    printf "%s\n" (for i in $result; echo $i; end | sort | uniq)
end
