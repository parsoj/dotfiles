function cwd_dir_list

    # Use ripgrep to list all directories under the workspace root
    find . -type d -not -path "*/.git*"
end
