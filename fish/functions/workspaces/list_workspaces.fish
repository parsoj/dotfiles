function list_workspaces
    set -l dirs (string split : $WS_DIRS)
    set -l result

    for dir in $dirs
        if test -d $dir
            set result $result (rg --files --glob '**/.workspace.json' --hidden --no-messages ~/workspaces/ | xargs -I {} dirname {})
        end
    end

    # Remove duplicates and print the result
    printf "%s\n" (for i in $result; echo $i; end | sort | uniq)
end
