function rd --description "cd to a directory within the current git repo"
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    test -n "$git_root"; or return 1
    # display paths relative to the repo root, tagged r/ for scope; re-anchor before cd'ing
    set -l selected (git_dir_list | string replace -- "$git_root/" "r/" | fzf --prompt="dir> ")
    test -n "$selected"; and dir_cd "$git_root/"(string replace -- "r/" "" "$selected")
end
