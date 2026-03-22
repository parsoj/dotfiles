function pagerduty_bulk_triage -d "Triage PagerDuty incidents using LLM categorization"
    # Check for required tools
    for tool in pd fzf jq claude
        if not command -q $tool
            switch $tool
                case pd
                    echo "PagerDuty CLI (pd) is not installed."
                    read -P "Install it via npm? [y/N] " confirm
                    if test "$confirm" = y -o "$confirm" = Y
                        npm install -g pagerduty-cli
                        echo "Installed. Run 'pd login' to authenticate, then re-run this command."
                        return 0
                    end
                case fzf
                    echo "fzf is not installed."
                    read -P "Install it via Homebrew? [y/N] " confirm
                    if test "$confirm" = y -o "$confirm" = Y
                        brew install fzf
                    end
                case jq
                    echo "jq is not installed."
                    read -P "Install it via Homebrew? [y/N] " confirm
                    if test "$confirm" = y -o "$confirm" = Y
                        brew install jq
                    end
                case claude
                    echo "Claude CLI is not installed."
                    echo "Install it from: https://docs.anthropic.com/en/docs/claude-code"
                    return 1
            end
            if not command -q $tool
                echo "Aborted."
                return 1
            end
        end
    end

    # Step 1: Pick a service using fzf
    echo "Fetching PagerDuty services..."
    set service (pd service list --json 2>/dev/null \
        | jq -r '.[] | "\(.id)\t\(.name)"' \
        | fzf --with-nth=2.. --delimiter='\t' --prompt="Select a service: " --height=~40%)

    if test -z "$service"
        echo "No service selected."
        return 0
    end

    set service_name (echo "$service" | cut -f2-)
    echo "Selected service: $service_name"
    echo ""

    # Step 2: Fetch all open incidents
    echo "Fetching open incidents..."
    set tmpfile (mktemp /tmp/pd-triage-XXXXXX.json)

    pd incident list -X "$service_name" --json 2>/dev/null \
        | jq '[.[] | {id: .id, title: .title, status: .status, created_at: .created_at}]' \
        > $tmpfile

    set total (jq 'length' $tmpfile)

    if test "$total" -eq 0
        echo "No open incidents."
        rm -f $tmpfile
        return 0
    end

    echo "Found $total open incidents. Categorizing with Claude..."
    echo ""

    # Step 3: Categorize with Claude
    set schema '{"type":"object","properties":{"categories":{"type":"array","items":{"type":"object","properties":{"name":{"type":"string","description":"Short category name"},"description":{"type":"string","description":"One sentence describing these incidents"},"incident_ids":{"type":"array","items":{"type":"string"}},"count":{"type":"integer"}},"required":["name","description","incident_ids","count"]}}},"required":["categories"]}'

    set categories_json (cat $tmpfile | claude -p \
        --model haiku \
        --output-format json \
        --json-schema "$schema" \
        --no-session-persistence \
        --allowedTools "" \
        "You are triaging PagerDuty incidents. Group these incidents into categories based on their titles. Each incident should appear in exactly one category. Return a JSON object with a 'categories' array. Each category should have: name (short label), description (one sentence), incident_ids (array of incident id strings), count (number of incidents). Sort categories by count descending." 2>/dev/null)

    if test $status -ne 0
        echo "Error: Claude categorization failed."
        rm -f $tmpfile
        return 1
    end

    set num_categories (echo "$categories_json" | jq '.result.categories | length')

    if test "$num_categories" -eq 0
        echo "No categories returned."
        rm -f $tmpfile
        return 0
    end

    # Step 4: Show summary
    echo "=== $total open incidents across $num_categories categories ==="
    echo ""

    for i in (seq 0 (math $num_categories - 1))
        set cat_name (echo "$categories_json" | jq -r ".result.categories[$i].name")
        set cat_desc (echo "$categories_json" | jq -r ".result.categories[$i].description")
        set cat_count (echo "$categories_json" | jq -r ".result.categories[$i].count")
        set cat_oldest (echo "$categories_json" | jq -r "[.result.categories[$i].incident_ids[] as \$id | input | select(.id == \$id) | .created_at] | sort | first // empty" --slurp $tmpfile 2>/dev/null)

        printf "  [%3s] %s — %s\n" "$cat_count" "$cat_name" "$cat_desc"
    end

    echo ""

    # Step 5: Walk through each category
    for i in (seq 0 (math $num_categories - 1))
        set cat_name (echo "$categories_json" | jq -r ".result.categories[$i].name")
        set cat_desc (echo "$categories_json" | jq -r ".result.categories[$i].description")
        set cat_count (echo "$categories_json" | jq -r ".result.categories[$i].count")
        set cat_ids (echo "$categories_json" | jq -r ".result.categories[$i].incident_ids[]")

        # Get time range from the incident data
        set timestamps (for id in $cat_ids
            jq -r ".[] | select(.id == \"$id\") | .created_at" $tmpfile
        end | sort)
        set oldest $timestamps[1]
        set newest $timestamps[-1]

        set oldest_rel (_pd_triage_relative_time "$oldest")
        set newest_rel (_pd_triage_relative_time "$newest")

        echo "──────────────────────────────────────────"
        echo "[(math $i + 1)/$num_categories] $cat_name ($cat_count incidents)"
        echo "  $cat_desc"
        echo "  Oldest: $oldest_rel | Newest: $newest_rel"
        echo ""
        echo "  r = resolve    a = acknowledge    m = merge    s = skip    o = open in browser"
        echo ""

        while true
            read -P "  Action: " action
            switch "$action"
                case r R
                    echo "  Resolving $cat_count incidents in batches of 50..."
                    _pd_triage_batch_cmd "pd incident resolve -p" $cat_ids
                    echo "  Done."
                    break
                case a A
                    echo "  Acknowledging $cat_count incidents in batches of 50..."
                    _pd_triage_batch_cmd "pd incident ack -p" $cat_ids
                    echo "  Done."
                    break
                case m M
                    if test "$cat_count" -lt 2
                        echo "  Only 1 incident, nothing to merge. Skipping."
                        break
                    end
                    # Use the most recent incident as the parent
                    set parent_id $cat_ids[-1]
                    echo "  Merging $cat_count incidents into $parent_id in batches of 50..."
                    _pd_triage_batch_cmd "pd incident merge -p -I $parent_id" $cat_ids
                    echo "  Merged."
                    echo ""
                    read -P "  Now what? (r = resolve, a = acknowledge, s = skip): " post_merge
                    switch "$post_merge"
                        case r R
                            pd incident resolve -i "$parent_id" 2>/dev/null
                            echo "  Resolved."
                        case a A
                            pd incident ack -i "$parent_id" 2>/dev/null
                            echo "  Acknowledged."
                        case '*'
                            echo "  Left as-is."
                    end
                    break
                case s S
                    echo "  Skipped."
                    break
                case o O
                    # Open first few in browser for context
                    set preview_ids $cat_ids[1..5]
                    printf '%s\n' $preview_ids | pd incident open -p 2>/dev/null
                    echo "  Opened "(count $preview_ids)" incidents in browser. Choose another action."
                case '*'
                    echo "  Unknown action. Use r/a/m/s/o."
            end
        end
        echo ""
    end

    echo "Triage complete."
    rm -f $tmpfile
end

# Helper: run a pd command in batches of 50 IDs
# Usage: _pd_triage_batch_cmd "pd incident resolve -p" $ids
function _pd_triage_batch_cmd
    set cmd $argv[1]
    set ids $argv[2..-1]
    set total (count $ids)
    set batch_size 50

    for batch_start in (seq 1 $batch_size $total)
        set batch_end (math "min($batch_start + $batch_size - 1, $total)")
        set batch $ids[$batch_start..$batch_end]
        printf '%s\n' $batch | eval $cmd 2>/dev/null
        echo "    Processed $batch_end / $total"
    end
end

# Helper: convert ISO timestamp to relative time string
function _pd_triage_relative_time -a timestamp
    if test -z "$timestamp"
        echo "unknown"
        return
    end

    set now (date +%s)
    set then (date -j -f "%Y-%m-%dT%H:%M:%SZ" "$timestamp" +%s 2>/dev/null)

    if test -z "$then"
        # Try with fractional seconds
        set cleaned (echo "$timestamp" | sed 's/\.[0-9]*Z$/Z/')
        set then (date -j -f "%Y-%m-%dT%H:%M:%SZ" "$cleaned" +%s 2>/dev/null)
    end

    if test -z "$then"
        echo "$timestamp"
        return
    end

    set diff (math $now - $then)

    if test $diff -lt 60
        echo $diff"s ago"
    else if test $diff -lt 3600
        echo (math "floor($diff / 60)")"m ago"
    else if test $diff -lt 86400
        echo (math "floor($diff / 3600)")"h ago"
    else
        echo (math "floor($diff / 86400)")"d ago"
    end
end
