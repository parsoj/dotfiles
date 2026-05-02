function git_dir_list --description "list directories under the current git repo (excluding .git)"
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    test -n "$git_root"; or return 1
    find $git_root -type d -not -path '*/.git/*'
end
