function workspace_list
    set -l dirs (string split : $WS_DIRS)
    test (count $dirs) -eq 0; and return 1
    command fd '.workspace.json' -H --glob --max-depth 4 --type f --exclude .git $dirs \
        | xargs -I {} dirname {} \
        | sort -u
end
