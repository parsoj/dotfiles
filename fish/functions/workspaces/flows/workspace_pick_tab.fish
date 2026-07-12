function workspace_pick_tab --description "pick a workspace and open it in a new Kitty tab"
    set -l ws (workspace_list 2>/dev/null | fzf \
        --prompt='workspace> ' \
        --height=100% \
        --layout=reverse \
        --border=rounded \
        --margin='15%,20%' \
        --padding='1,2' \
        --info=inline \
        --preview='ls -la {} | head -80' \
        --preview-window='right,50%,border-left')

    test -n "$ws"; or return 0
    workspace_kitty_tab_open "$ws"
end
