function cd_workspace_directory
    set -l ws_root (workspace_root)
    test -n "$ws_root"; or return 1
    # display paths relative to the workspace root, tagged w/ for scope; re-anchor before cd'ing
    set -l selected (workspace_dir_list | string replace -- "$ws_root/" "w/" | fzf --prompt="dir> ")
    test -n "$selected"; and dir_cd "$ws_root/"(string replace -- "w/" "" "$selected")
end
