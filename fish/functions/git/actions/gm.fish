function gm
    if test -z "$argv"
        echo "Error: No commit message provided." >&2
        return 1
    end

    set commit_message (string join " " $argv)

    if test (git diff --cached --name-only | line_count) -gt 0
        gt modify -c -m "$commit_message" 2>/dev/null
        or git commit -m "$commit_message"
    else
        gt modify -c -a -m "$commit_message" 2>/dev/null
        or git commit -a -m "$commit_message"
    end
end
