function print_workspace_root
    set current_dir (pwd)
    set home_dir ~

    while test "$current_dir" != "$home_dir"
        set workspace_files (ls -a $current_dir | grep '\\.workspace')

        if test -n "$workspace_files"
            echo "$current_dir"
            return 0
        end

        set current_dir (dirname $current_dir)

    end

    echo "Reached home directory without finding a workspace"
    return 1
end
