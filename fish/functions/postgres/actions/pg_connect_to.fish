# @inputs entry:string  (host:port:db:user, * means default)
function pg_connect_to --argument-names entry --description "connect via pgcli using a host:port:db:user pgpass-style entry"
    test -n "$entry"; or return 1
    type -q pgcli; or begin
        echo "pg_connect_to: pgcli not found in PATH" >&2
        return 1
    end

    set -l parts (string split ":" -- $entry)
    set -l host $parts[1]
    set -l port $parts[2]
    set -l database $parts[3]
    set -l user $parts[4]

    set -l args
    test "$host" != "*"    ; and set args $args -h $host
    test "$port" != "*"    ; and set args $args -p $port
    test "$user" != "*"    ; and set args $args -U $user
    test "$database" = "*" ; and set database

    echo "Connecting with pgcli $args $database"
    pgcli $args $database
end
