function list_cwd_child_directories

    # Use ripgrep to list all directories under the workspace root
    find . -type d -not -path "*/.git*"
end
