function l --description "pick and run a launcher item"
    # The global fzf config uses --height 40%, which is nice for inline shell
    # widgets but makes full-screen surfaces like Kitty quick-access feel cramped.
    set -l fzf_launch_opts (string replace -r --all '(^|\s)--height(=|\s+)[~\-]?\d+%?' '' -- "$FZF_DEFAULT_OPTS")

    set -l selection (launcher_item_list | env FZF_DEFAULT_OPTS="$fzf_launch_opts" fzf \
        --layout=default \
        --delimiter='\t' \
        --with-nth=3 \
        --prompt='Launch > ')

    if test -z "$selection"
        printf '\033[2J\033[H'
        return 0
    end

    launcher_item_run "$selection"
end
