function tmux_watch_ci --description "Watch a GitHub Actions run with tmux monitoring state"
    if test (count $argv) -eq 0
        echo "Usage: tmux_watch_ci <run-url-or-id> [repo]"
        echo "  run-url-or-id: GitHub Actions run URL or numeric run ID"
        echo "  repo:          owner/repo (optional if run URL is provided)"
        return 1
    end

    set -l run_arg $argv[1]
    set -l repo_flag

    # If a second arg is provided, use it as --repo
    if test (count $argv) -ge 2
        set repo_flag --repo $argv[2]
    end

    # Extract run ID from URL if needed
    set -l run_id
    if string match -qr '/runs/(\d+)' -- "$run_arg"
        set run_id (string match -r '/runs/(\d+)' -- "$run_arg")[2]
        # Extract owner/repo from URL if --repo not given
        if test -z "$repo_flag"
            set -l repo_match (string match -r 'github\.com/([^/]+/[^/]+)/' -- "$run_arg")
            if test (count $repo_match) -ge 2
                set repo_flag --repo $repo_match[2]
            end
        end
    else
        set run_id $run_arg
    end

    # Require tmux
    if not set -q TMUX
        echo "Error: not inside a tmux session"
        return 1
    end

    set -l window_id (tmux display-message -p '#{window_id}')
    set -l lock "/tmp/tmux-claude-monitoring-$window_id"

    # Create lock file and set monitoring state
    touch $lock
    echo "" | ~/.claude/hooks/tmux-tab-state.sh monitoring

    # Watch the run
    set -l exit_code
    gh run watch $run_id $repo_flag --exit-status
    set exit_code $status

    # Clean up lock file and restore idle state
    rm -f $lock
    echo "" | ~/.claude/hooks/tmux-tab-state.sh idle

    # Report result
    if test $exit_code -eq 0
        echo "✅ CI run $run_id passed"
    else
        echo "❌ CI run $run_id failed (exit code $exit_code)"
    end

    return $exit_code
end
