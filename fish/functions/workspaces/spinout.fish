function spinout
    # Verify we're inside a repo under ~/code/repos/
    set -l repo_root (git rev-parse --show-toplevel 2>/dev/null)
    or begin
        echo "Error: not inside a git repository." >&2
        return 1
    end

    if not string match -q "$HOME/code/repos/*" "$repo_root"
        echo "Error: must be run from a repo under ~/code/repos/" >&2
        return 1
    end

    set -l repo_name (basename "$repo_root")

    # Workspace name from args or prompt
    set -l name (string join "-" $argv)
    if test -z "$name"
        read -P "Workspace name: " name
    end
    if test -z "$name"
        echo "No workspace name provided. Aborting." >&2
        return 1
    end

    # Stash uncommitted changes if any
    set -l did_stash false
    if not git -C "$repo_root" diff --quiet 2>/dev/null; or not git -C "$repo_root" diff --cached --quiet 2>/dev/null
        git -C "$repo_root" stash --include-untracked
        or return 1
        set did_stash true
    end

    # Create workspace and add repo as worktree
    create_new_workspace --no-clipboard $name
    or return 1

    add_repo $repo_name
    or return 1

    cd $repo_name
    or return 1

    # Transfer stashed changes to the worktree
    if test "$did_stash" = true
        git stash pop
        or begin
            echo "Warning: stash pop had conflicts — resolve manually." >&2
        end
    end

    # Reset the main repo back to origin/main
    set -l default_branch (git -C "$repo_root" rev-parse --abbrev-ref origin/HEAD 2>/dev/null | string replace "origin/" "")
    if test -z "$default_branch"
        set default_branch main
    end
    git -C "$repo_root" reset --hard "origin/$default_branch"
    git -C "$repo_root" clean -fd

    echo "Workspace '$name' ready with $repo_name worktree."
end
