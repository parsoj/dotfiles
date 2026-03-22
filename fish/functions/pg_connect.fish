function pg_connect --description 'Pick a .pgpass entry via fzf and connect with pgcli'
      set -l pgpassfile (set -q PGPASSFILE; and printf %s "$PGPASSFILE"; or printf %s ~/.pgpass)

      if not test -r "$pgpassfile"
          echo "pgpass_connect: cannot read $pgpassfile" >&2
          return 1
      end

      if not type -q fzf
          echo "pgpass_connect: fzf not found in PATH" >&2
          return 1
      end

      if not type -q pgcli
          echo "pgpass_connect: pgcli not found in PATH" >&2
          return 1
      end

      set -l selection (command awk -F: '
          /^[[:space:]]*#/ || NF < 5 { next }
          { printf "%s:%s:%s:%s\n", $1, $2, $3, $4 }
      ' "$pgpassfile" | fzf --prompt="pgpass> " --height=40% --border)

      if test -z "$selection"
          echo "pgpass_connect: no entry selected" >&2
          return 1
      end

      set -l parts (string split ":" -- $selection)
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
