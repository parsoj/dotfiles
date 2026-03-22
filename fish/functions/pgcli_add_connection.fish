function pgcli_add_connection
    set -l connection_string $argv[1]
    set -l alias ""
    set -l host ""
    set -l user ""
    set -l password ""
    set -l database ""
    set -l port ""
    set -l hostdb ""
    set -l hostport ""

    # Parse connection string if provided
    if test -n "$connection_string"
        # Expected format: postgresql://user:password@host:port/database
        # or postgres://user:password@host:port/database
        set connection_string (string replace -ra '^postgres(ql)?://' '' "$connection_string")

        # Extract user and password
        if string match -q '*@*' "$connection_string"
            set -l userpass (string split '@' "$connection_string")[1]
            set hostdb (string split '@' "$connection_string")[2]

            if string match -q '*:*' "$userpass"
                set user (string split ':' "$userpass")[1]
                set password (string split ':' "$userpass")[2]
            else
                set user "$userpass"
            end
        else
            set hostdb "$connection_string"
        end

        # Extract host, port, database
        if string match -q '*/*' "$hostdb"
            set hostport (string split '/' "$hostdb")[1]
            set database (string split '/' "$hostdb")[2]
            # Strip query string parameters (e.g., ?sslmode=require)
            if string match -q '*\?*' "$database"
                set database (string split '?' "$database")[1]
            end
        else
            set hostport "$hostdb"
            set database ""
        end

        if string match -q '*:*' "$hostport"
            set host (string split ':' "$hostport")[1]
            set port (string split ':' "$hostport")[2]
        else
            set host "$hostport"
            set port "5432"
        end
    end

    # Always prompt for alias (with database name as default if available)
    if test -n "$database"
        read -P "Enter connection alias [$database]: " alias
        if test -z "$alias"
            set alias "$database"
        end
    else
        read -P "Enter connection alias: " alias
    end

    # Prompt for other missing fields
    if test -z "$host"
        read -P "Enter host (e.g., localhost): " host
    end

    if test -z "$user"
        read -P "Enter username: " user
    end

    if test -z "$password"
        read -P "Enter password: " -s password
    end

    if test -z "$database"
        read -P "Enter database name: " database
    end

    if test -z "$port"
        set port "5432"
    end

    # Validate inputs
    if test -z "$alias" -o -z "$host" -o -z "$user" -o -z "$database"
        echo "Error: Missing required fields"
        return 1
    end

    # Ensure directories exist
    mkdir -p ~/.config/pgcli
    touch ~/.pgpass

    # Add to .pgpass
    set -l pgpass_entry "$host:$port:$database:$user:$password"

    # Remove existing entry for this host/port/database/user if it exists
    if test -f ~/.pgpass
        string match -rv "^$host:$port:$database:$user:" < ~/.pgpass > /tmp/pgpass.tmp
        mv /tmp/pgpass.tmp ~/.pgpass
    end

    # Append new entry
    echo "$pgpass_entry" >> ~/.pgpass
    chmod 600 ~/.pgpass

    # Add to pgcli config
    set -l config_file ~/.config/pgcli/config

    # Check if config exists and create if not
    if not test -f "$config_file"
        echo '[main]' > "$config_file"
        echo '' >> "$config_file"
        echo '[alias_dsn]' >> "$config_file"
    end

    # Ensure [alias_dsn] section exists
    if not grep -q '^\[alias_dsn\]' "$config_file"
        echo '' >> "$config_file"
        echo '[alias_dsn]' >> "$config_file"
    end

    # Remove existing alias if present, then add new one
    set -l dsn_entry "$alias = host=$host user=$user dbname=$database port=$port"

    # Remove old entry for this alias if it exists
    string match -rv "^$alias = " < "$config_file" > /tmp/pgcli_config.tmp
    mv /tmp/pgcli_config.tmp "$config_file"

    # Append new entry at end of file (after [alias_dsn] section)
    echo "$dsn_entry" >> "$config_file"

    echo "Connection '$alias' added successfully!"
    echo "  Connect with: pgcli -D $alias"
end
