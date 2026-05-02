function cd_workspace_directory
    set -l selected (workspace_dir_list | fzf)
    test -n "$selected"; and dir_cd $selected
end
