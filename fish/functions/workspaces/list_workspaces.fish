function list_workspaces
    echo $WS_DIRS
    set -l dirs (string split : $WS_DIRS)
    set -l result

    for dir in $dirs
        if test -d $dir
            echo "checking dir $dir"
            set result $result (rg --files --glob '**/.workspace.json' --hidden --no-messages $dir | xargs -I {} dirname {})
        end
    end

    # Remove duplicates and print the result
    printf "%s\n" (for i in $result; echo $i; end | sort | uniq)
end
