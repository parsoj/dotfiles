function cf
    set file (cfls | fzf)

    # Check if the file path is not empty and if it exists
    if test -n "$file" -a -e "$file"
        nvim $file
    else
        echo "No config file selected, exiting."
    end
end
