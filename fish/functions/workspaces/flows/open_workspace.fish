function open_workspace
    set -l ws (workspace_list | fzf)
    test -n "$ws"; and zed_open $ws
end
