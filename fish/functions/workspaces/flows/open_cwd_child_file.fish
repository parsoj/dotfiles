function open_cwd_child_file
    set -l selected (cwd_file_list | fzf)
    test -n "$selected"; and nvim_open $selected
end
