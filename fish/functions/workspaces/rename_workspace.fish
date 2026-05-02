function rename_workspace
    set -l new_name (string join "-" $argv)

    # Find current workspace root
    set -l ws_root (workspace_root 2>/dev/null)
    if test -z "$ws_root"
        echo "Error: not in a workspace." >&2
        return 1
    end

    set -l old_name (basename "$ws_root")
    set -l ws_parent (dirname "$ws_root")

    if test -z "$new_name"
        read -P "Rename '$old_name' to: " new_name
    end

    if test -z "$new_name"
        echo "No name provided. Aborting." >&2
        return 1
    end

    if test "$old_name" = "$new_name"
        echo "Already named '$old_name'." >&2
        return 1
    end

    set -l new_path "$ws_parent/$new_name"
    if test -d "$new_path"
        echo "Error: '$new_path' already exists." >&2
        return 1
    end

    # Find all git worktrees in this workspace
    set -l worktree_dirs
    for d in $ws_root/*/
        if test -f "$d/.git"
            set -a worktree_dirs $d
        end
    end

    # Rename the folder
    mv "$ws_root" "$new_path"
    or begin
        echo "Error: failed to rename workspace folder." >&2
        return 1
    end

    # Update git worktree references
    for d in $worktree_dirs
        set -l repo_name (basename "$d")
        set -l new_wt_path "$new_path/$repo_name"

        # Read the gitdir pointer to find the repo's worktree metadata
        set -l gitdir_content (string trim (cat "$new_wt_path/.git"))
        set -l repo_wt_dir (string replace "gitdir: " "" "$gitdir_content")

        # Update the repo's pointer back to the worktree
        if test -f "$repo_wt_dir/gitdir"
            echo "$new_wt_path/.git" > "$repo_wt_dir/gitdir"
        end
    end

    cd "$new_path"
    echo "Renamed workspace: $old_name → $new_name"
end
