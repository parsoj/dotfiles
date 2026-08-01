function cwd_dir_list

    # list every directory under the cwd (excluding .git), absolute paths
    find (pwd) -mindepth 1 -name .git -prune -o -mindepth 1 -type d -print
end
