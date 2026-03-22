function send_to_work_inbox -d "Prepend text to WORK_INBOX_FILE_PATH (reads stdin or prompts for input)"
    if not set -q WORK_INBOX_FILE_PATH
        echo "Error: WORK_INBOX_FILE_PATH is not set" >&2
        return 1
    end

    if not test -f "$WORK_INBOX_FILE_PATH"
        echo "Error: File not found: $WORK_INBOX_FILE_PATH" >&2
        return 1
    end

    # Read from args, stdin, or prompt
    if test (count $argv) -gt 0
        set input "$argv"
    else if not isatty stdin
        set input (cat)
    else
        read -p 'echo "Work Inbox> "' -l input
        if test -z "$input"
            echo "No input provided." >&2
            return 1
        end
    end

    set -l tmpfile (mktemp)
    echo "$input" >$tmpfile
    echo "" >>$tmpfile
    cat "$WORK_INBOX_FILE_PATH" >>$tmpfile
    mv $tmpfile "$WORK_INBOX_FILE_PATH"

    echo "Sent to work inbox."
end
