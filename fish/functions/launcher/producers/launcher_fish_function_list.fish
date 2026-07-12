function launcher_fish_function_list --description "list fish functions as launcher items"
    set -l cache_dir (set -q XDG_CACHE_HOME; and echo $XDG_CACHE_HOME; or echo $HOME/.cache)/launcher
    set -l functions_cache $cache_dir/fish-functions.tsv

    if not test -s "$functions_cache"
        command -q launcher_cache_refresh; and launcher_cache_refresh >/dev/null 2>&1
    end

    if test -s "$functions_cache"
        command awk -F' ## ' '/^FUNC:/ { sub(/^FUNC:/, "", $1); printf "FUNC\t%s\t%s\n", $1, $2 }' "$functions_cache"
    end
end
