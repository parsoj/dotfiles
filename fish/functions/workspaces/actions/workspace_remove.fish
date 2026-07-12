# @destructive yes
# @inputs      path:string
function workspace_remove --argument-names ws --description "remove a workspace: child worktrees, root worktree, root branch"
    test -n "$ws"
    or begin
        echo "workspace_remove: no workspace path given" >&2
        return 1
    end

    set ws (realpath "$ws" 2>/dev/null)
    if test -z "$ws"; or not test -d "$ws"
        echo "workspace_remove: not a directory: $argv[1]" >&2
        return 1
    end

    if not test -f "$ws/.workspace.json"
        echo "workspace_remove: $ws is not a workspace (no .workspace.json)" >&2
        return 1
    end

    # Remove child repo worktrees first — their registrations live in the
    # canonical repos under ~/code/repos. (rm -rf'ing instead is what used to
    # leave the stale registrations repo_add has to prune around.)
    for d in $ws/*/
        set -l child (string trim -rc / "$d")
        if test -f "$child/.git"
            set -l common (git -C "$child" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
            if test -n "$common"
                set -l main_repo (dirname "$common")
                set -l child_branch (git -C "$child" branch --show-current)
                echo "Removing worktree $child"
                git -C "$main_repo" worktree remove --force --force "$child"
                or echo "Warning: failed to remove worktree $child — remove manually." >&2
                # Safe-delete the child branch: -d only succeeds if it has no
                # unmerged work, so branches backing PRs/WIP are kept.
                if test -n "$child_branch"
                    git -C "$main_repo" branch -d "$child_branch" >/dev/null 2>&1
                end
            end
        end
    end

    # Remove the root: worktree of workspace-home (plus its branch), or a
    # plain directory for legacy roots.
    if test -f "$ws/.git"
        set -l ws_home ~/code/repos/workspace-home
        set -l branch (git -C "$ws" branch --show-current)
        git -C $ws_home worktree remove --force --force "$ws"
        or begin
            echo "Warning: root worktree remove failed; deleting directory and pruning." >&2
            command rm -rf "$ws"
            git -C $ws_home worktree prune
        end
        if test -n "$branch"
            git -C $ws_home branch -D "$branch" >/dev/null 2>&1
        end
    else
        command rm -rf "$ws"
    end

    echo "Removed workspace $ws"
end
