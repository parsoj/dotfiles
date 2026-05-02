# @raycast              yes
# @raycast-title        Connect to Postgres
# @raycast-description  Pick a .pgpass entry and connect with pgcli
# @raycast-producer     pgpass_list
# @raycast-action       pgpass_connect
function pg_connect --description "pick a .pgpass entry and connect with pgcli"
    type -q fzf; or begin
        echo "pg_connect: fzf not found in PATH" >&2
        return 1
    end

    set -l entry (pgpass_list | fzf --prompt="pgpass> " --height=40% --border)
    test -n "$entry"; or begin
        echo "pg_connect: no entry selected" >&2
        return 1
    end

    pgpass_connect $entry
end
