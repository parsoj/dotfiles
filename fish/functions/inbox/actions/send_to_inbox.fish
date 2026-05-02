function send_to_inbox -d "Prepend text to INBOX_FILE_PATH (reads stdin or prompts for input)"
    if not set -q INBOX_FILE_PATH
        echo "Error: INBOX_FILE_PATH is not set" >&2
        return 1
    end

    if not test -f "$INBOX_FILE_PATH"
        echo "Error: File not found: $INBOX_FILE_PATH" >&2
        return 1
    end

    # Read from args, stdin, or prompt
    if test (count $argv) -gt 0
        set input "$argv"
    else if not isatty stdin
        set input (cat)
    else
        read -p 'echo "Inbox> "' -l input
        if test -z "$input"
            echo "No input provided." >&2
            return 1
        end
    end

    set -l tmpfile (mktemp)
    echo "$input" >$tmpfile
    echo "" >>$tmpfile
    cat "$INBOX_FILE_PATH" >>$tmpfile
    mv $tmpfile "$INBOX_FILE_PATH"

    echo "Sent to inbox."
end
