function rd --description "cd to a directory within the current git repo using fzf"
    set git_root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$git_root"
        echo "Not inside a git repository"
        return 1
    end

    set selected (find $git_root -type d -not -path '*/.git/*' | fzf)
    if test -z "$selected"
        return 1
    end

    cd "$selected"
end
