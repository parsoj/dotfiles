
function cwd_file_list

    # Use ripgrep to list all directories under the workspace root
    find . -not -path "*/.git*"
end
