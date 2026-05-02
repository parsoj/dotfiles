function cd_cwd_child_directory
    set -l selected (cwd_dir_list | fzf)
    test -n "$selected"; and dir_cd $selected
end
