function rd --description "cd to a directory within the current git repo"
    set -l selected (git_dir_list | fzf --prompt="dir> ")
    test -n "$selected"; and dir_cd $selected
end
