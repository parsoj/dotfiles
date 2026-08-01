function cd_cwd_child_directory
    set -l cwd (pwd)
    # display paths relative to the cwd, tagged ./ for scope; re-anchor before cd'ing
    set -l selected (cwd_dir_list | string replace -- "$cwd/" "./" | fzf --prompt="dir> ")
    test -n "$selected"; and dir_cd "$cwd/"(string replace -- "./" "" "$selected")
end
