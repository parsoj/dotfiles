function go_to_workspace
    set -l ws (workspace_list | fzf)
    test -n "$ws"; and dir_cd $ws
end
