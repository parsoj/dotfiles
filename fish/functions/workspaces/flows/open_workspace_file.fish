function open_workspace_file
    set -l selected (workspace_file_list | fzf)
    test -n "$selected"; and nvim_open $selected
end
