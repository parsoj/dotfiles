function workspace_clean
    # Gather workspace paths sorted by modification time (oldest first)
    set -l dirs (string split : $WS_DIRS)
    set -l workspaces

    for dir in $dirs
        if test -d $dir
            set workspaces $workspaces (rg --files --glob '**/.workspace.json' --hidden --no-messages $dir | xargs -I {} dirname {})
        end
    end

    # Deduplicate
    set workspaces (printf "%s\n" $workspaces | sort -u)

    if test (count $workspaces) -eq 0
        echo "No workspaces found."
        return 1
    end

    # Build lines with modification time for sorting: "epoch_seconds path"
    set -l entries
    for ws in $workspaces
        set -l mtime (stat -f '%m' "$ws" 2>/dev/null)
        if test -n "$mtime"
            set entries $entries "$mtime $ws"
        end
    end

    # Sort by epoch (oldest first), then strip the epoch prefix for display
    set -l sorted_paths (printf "%s\n" $entries | sort -n | string replace -r '^\d+ ' '')

    # Use fzf with multi-select to pick workspaces to delete
    set -l selected (printf "%s\n" $sorted_paths | fzf --multi \
        --bind 'j:down,k:up' \
        --prompt="Select workspaces to delete (TAB to mark, ENTER to confirm): ")

    if test -z "$selected"
        echo "No workspaces selected. Aborting."
        return 1
    end

    echo "The following workspaces will be deleted:"
    for ws in $selected
        echo "  $ws"
    end

    read -P "Proceed? [y/N] " confirm
    if test "$confirm" != y -a "$confirm" != Y
        echo "Aborted."
        return 1
    end

    for ws in $selected
        echo "Deleting $ws ..."
        command rm -rf "$ws" &
    end

    echo "Delete jobs launched in background."
end
