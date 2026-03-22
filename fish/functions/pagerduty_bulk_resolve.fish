function pagerduty_bulk_resolve -d "Bulk resolve PagerDuty incidents for a selected service"
    # Check for required tools
    if not command -q pd
        echo "PagerDuty CLI (pd) is not installed."
        read -P "Install it via npm? [y/N] " confirm
        if test "$confirm" = y -o "$confirm" = Y
            npm install -g pagerduty-cli
            echo "Installed. Run 'pd login' to authenticate, then re-run this command."
            return 0
        else
            echo "Aborted."
            return 1
        end
    end

    if not command -q fzf
        echo "fzf is not installed."
        read -P "Install it via Homebrew? [y/N] " confirm
        if test "$confirm" = y -o "$confirm" = Y
            brew install fzf
        else
            echo "Aborted."
            return 1
        end
    end

    if not command -q jq
        echo "jq is not installed."
        read -P "Install it via Homebrew? [y/N] " confirm
        if test "$confirm" = y -o "$confirm" = Y
            brew install jq
        else
            echo "Aborted."
            return 1
        end
    end

    # Step 1: Pick a service using fzf
    echo "Fetching PagerDuty services..."
    set service (pd service list --json 2>/dev/null \
        | jq -r '.[] | "\(.id)\t\(.name)"' \
        | fzf --with-nth=2.. --delimiter='\t' --prompt="Select a service: " --height=~40%)

    if test -z "$service"
        echo "No service selected. Exiting."
        return 0
    end

    set service_id (echo "$service" | cut -f1)
    set service_name (echo "$service" | cut -f2-)

    echo ""
    echo "Selected service: $service_name ($service_id)"
    echo ""

    # Step 2: Count triggered and acknowledged incidents
    echo "Counting open incidents..."
    set triggered (pd incident list --pipe -X "$service_name" -s triggered 2>/dev/null | count)
    set acknowledged (pd incident list --pipe -X "$service_name" -s acknowledged 2>/dev/null | count)
    set total (math $triggered + $acknowledged)

    echo "  Triggered:    $triggered"
    echo "  Acknowledged: $acknowledged"
    echo "  Total:        $total"
    echo ""

    if test "$total" -eq 0
        echo "No open incidents to resolve."
        return 0
    end

    # Step 3: Ask for confirmation
    read -P "Resolve all $total incidents on \"$service_name\"? [y/N] " confirm
    if test "$confirm" != y -a "$confirm" != Y
        echo "Aborted."
        return 0
    end

    # Step 4: Resolve all open incidents in batches of 50
    echo ""
    echo "Resolving $total incidents in batches of 50..."
    set all_ids (pd incident list --pipe -X "$service_name" 2>/dev/null)
    set batch_size 50
    set id_count (count $all_ids)

    for batch_start in (seq 1 $batch_size $id_count)
        set batch_end (math "min($batch_start + $batch_size - 1, $id_count)")
        set batch $all_ids[$batch_start..$batch_end]
        printf '%s\n' $batch | pd incident resolve -p 2>/dev/null
        echo "  Processed $batch_end / $id_count"
    end

    echo ""
    echo "Done. Resolved $id_count incidents on \"$service_name\"."
end
