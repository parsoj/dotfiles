function kill_port_listeners
    if test -z "$argv[1]"
        echo "Usage: kill_port_listeners <port>" >&2
        return 1
    end
    set -l pids (lsof -ti :$argv[1])
    if test -z "$pids"
        echo "No processes listening on port $argv[1]"
        return 0
    end
    kill $pids
    echo "Killed processes on port $argv[1]: $pids"
end
