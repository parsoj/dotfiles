function pgpass_list --description "list entries from ~/.pgpass as host:port:db:user lines"
    set -l pgpassfile (set -q PGPASSFILE; and printf %s "$PGPASSFILE"; or printf %s ~/.pgpass)
    test -r "$pgpassfile"; or return 1

    command awk -F: '
        /^[[:space:]]*#/ || NF < 5 { next }
        { printf "%s:%s:%s:%s\n", $1, $2, $3, $4 }
    ' "$pgpassfile"
end
