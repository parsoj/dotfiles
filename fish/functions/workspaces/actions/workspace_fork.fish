# @inputs name:string (new workspace name; run from inside the source workspace)
function workspace_fork --argument-names name --description "fork the current workspace: root worktree + child branches off source HEADs + dirty state"
    if test -z "$name"
        echo "usage: workspace_fork <new-workspace-name>" >&2
        return 1
    end

    set -l src (workspace_root)
    or return 1

    set -l ws_home ~/code/repos/workspace-home
    set -l dest ~/code/workspaces/$name
    if test -e "$dest"
        echo "workspace_fork: $dest already exists" >&2
        return 1
    end

    if not test -f "$src/.git"
        echo "workspace_fork: source root is not a workspace-home worktree (run workspace_migrate_to_shell_repo)" >&2
        return 1
    end

    set -l branch (workspace_branch_name "$name")
    set -l src_branch (git -C "$src" branch --show-current)
    if test -z "$src_branch"
        echo "workspace_fork: source root is not on a branch" >&2
        return 1
    end

    # Snapshot any uncommitted manifest edits so the fork inherits them
    if not git -C "$src" diff --quiet HEAD -- .workspace.json 2>/dev/null
        git -C "$src" add .workspace.json
        git -C "$src" commit -q -m "workspace: manifest snapshot before fork"
    end

    echo "Forking $src → $dest (branch: $branch)"
    git -C $ws_home worktree add -q -b "$branch" "$dest" "$src_branch"
    or return 1

    # The post-checkout hook already ran workspace_sync (children branch off
    # the source branches, since those are checked out in the source). Run it
    # again explicitly in case hooks were bypassed — it's idempotent.
    workspace_sync "$dest" >/dev/null 2>&1

    # Duplicate dirty state per child (source stays untouched)
    for d in $src/*/
        set -l child (string trim -rc / "$d")
        test -f "$child/.git"; or continue
        set -l rname (basename "$child")
        set -l destchild "$dest/$rname"

        if not test -d "$destchild"
            echo "warn: $rname missing in fork (not in manifest?) — dirty state not copied" >&2
            continue
        end

        if not git -C "$child" diff --quiet HEAD 2>/dev/null
            git -C "$child" diff --binary HEAD | git -C "$destchild" apply --binary
            and echo "copied tracked changes: $rname"
            or echo "warn: failed to apply tracked changes for $rname — copy manually" >&2
        end

        set -l untracked (git -C "$child" ls-files --others --exclude-standard | string match -rv '/$')
        if test (count $untracked) -gt 0
            printf '%s\0' $untracked | tar -C "$child" -cf - --null -T - 2>/dev/null | tar -C "$destchild" -xf -
            and echo "copied "(count $untracked)" untracked files: $rname"
        end

        # Record the child's actual fork branch in the fork's manifest
        set -l actual (git -C "$destchild" branch --show-current)
        if test -n "$actual"
            set -l tmp (mktemp)
            jq --arg n "$rname" --arg b "$actual" \
                '(.repos //= []) | .repos |= map(if .name == $n then .branch = $b else . end)' \
                "$dest/.workspace.json" > "$tmp"; and mv "$tmp" "$dest/.workspace.json"
        end
    end

    # Copy untracked root files (notes, scratch docs); nested repo dirs show
    # as "name/" entries and are excluded — they were handled above
    set -l root_files (git -C "$src" ls-files --others --exclude-standard | string match -rv '/$')
    if test (count $root_files) -gt 0
        printf '%s\0' $root_files | tar -C "$src" -cf - --null -T - 2>/dev/null | tar -C "$dest" -xf -
        echo "copied "(count $root_files)" untracked root files"
    end

    # Commit the fork's manifest branch updates
    if not git -C "$dest" diff --quiet HEAD -- .workspace.json 2>/dev/null
        git -C "$dest" add .workspace.json
        git -C "$dest" commit -q -m "workspace: fork of $src_branch"
    end

    if test -d "$dest/Tennr"; and command -q gt
        echo "note: Tennr fork is not graphite-tracked yet — run 'gt track' in $dest/Tennr"
    end

    echo "Forked. New workspace: $dest"
end
