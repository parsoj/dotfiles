function rr
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$git_root"
        echo "Not inside a git repository."
    else
        cd $git_root
    end
end
