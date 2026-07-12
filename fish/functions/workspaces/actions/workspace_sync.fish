# @inputs [workspace_path:string] (defaults to current workspace)
function workspace_sync --description "materialize child repo worktrees from the workspace manifest"
    set -l ws $argv[1]
    if test -z "$ws"
        set ws (workspace_root)
        or return 1
    end

    set -l manifest "$ws/.workspace.json"
    test -s "$manifest"; or return 0

    set -l root_branch (git -C "$ws" branch --show-current 2>/dev/null)

    for line in (jq -r '(.repos // [])[] | "\(.name)\t\(.branch)"' "$manifest" 2>/dev/null)
        set -l parts (string split \t -- $line)
        set -l rname $parts[1]
        set -l rbranch $parts[2]
        test -n "$rname" -a -n "$rbranch"; or continue

        set -l dest "$ws/$rname"
        test -e "$dest"; and continue

        set -l repo ~/code/repos/$rname
        if not test -d "$repo"
            echo "workspace_sync: repo '$rname' not found under ~/code/repos — skipping" >&2
            continue
        end

        if git -C "$repo" show-ref --verify --quiet "refs/heads/$rbranch"
            # Recorded branch exists: check it out, or — if it's checked out in
            # another workspace's worktree — branch off it using this
            # workspace's own name (fork semantics).
            git -C "$repo" worktree add -q "$dest" "$rbranch" 2>/dev/null
            or begin
                test -n "$root_branch"
                and git -C "$repo" worktree add -q -b "$root_branch" "$dest" "$rbranch"
            end
        else
            # Recorded branch doesn't exist yet: create it (matches repo_add)
            git -C "$repo" worktree add -q -b "$rbranch" "$dest"
        end
        or begin
            echo "workspace_sync: failed to add worktree for '$rname'" >&2
            continue
        end

        worktree_setup_apply "$repo" "$dest"
        echo "synced: $rname"
    end
end
