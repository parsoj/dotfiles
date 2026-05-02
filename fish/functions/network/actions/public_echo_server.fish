function public_echo_server -d "Start an echo server exposed via ngrok"
    argparse 'h/help' 'p/port=!_validate_int' -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: public_echo_server [--port PORT]"
        echo ""
        echo "Starts a local echo server and exposes it publicly via ngrok."
        echo "All incoming requests are logged with headers and body."
        echo ""
        echo "  --port PORT  Local port (default: 14700)"
        echo ""
        echo "Press Ctrl+C to stop both."
        return 0
    end

    if not command -q ngrok
        echo "ngrok not found. Install with: brew install ngrok"
        return 1
    end

    set -l port (test -n "$_flag_port" && echo $_flag_port || echo 14700)

    # Start ngrok in background, suppress its TUI output
    set -l ngrok_log (mktemp)
    ngrok http $port &>$ngrok_log &
    set -l ngrok_pid $last_pid

    # Wait for ngrok API to be ready
    set -l url ""
    for i in (seq 10)
        sleep 0.5
        # Check if ngrok died
        if not kill -0 $ngrok_pid 2>/dev/null
            echo "--- ngrok ---"
            echo "ngrok failed to start:"
            cat $ngrok_log
            rm -f $ngrok_log
            return 1
        end
        set url (curl -s http://127.0.0.1:4040/api/tunnels 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['tunnels'][0]['public_url'])" 2>/dev/null)
        if test -n "$url"
            break
        end
    end

    rm -f $ngrok_log

    if test -z "$url"
        echo "--- ngrok ---"
        echo "ngrok started but could not retrieve tunnel URL"
        echo "Check http://127.0.0.1:4040"
        kill $ngrok_pid 2>/dev/null
        return 1
    end

    echo "--- ngrok ---"
    echo "Tunnel:   $url"
    echo "Inspector: http://127.0.0.1:4040"
    echo ""
    echo "--- echo server ---"

    # Echo server runs in foreground — Ctrl+C kills it
    localhost_echo_server --port $port

    # Clean up ngrok when echo server exits
    kill $ngrok_pid 2>/dev/null
    echo ""
    echo "--- stopped ---"
end
