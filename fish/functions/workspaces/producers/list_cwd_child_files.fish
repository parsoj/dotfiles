
function list_cwd_child_files

    # Use ripgrep to list all directories under the workspace root
    find . -not -path "*/.git*"
end
