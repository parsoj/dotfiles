# @inputs  path:string
# @runs-in terminal
function workspace_kitty_tab_open --argument-names path --description "open a workspace in a new Kitty tab"
    test -n "$path"; or return 1
    test -d "$path"; or begin
        echo "workspace_kitty_tab_open: not a directory: $path" >&2
        return 1
    end

    set -l title (basename "$path")

    if set -q KITTY_WINDOW_ID
        command kitty @ launch --type=tab --cwd "$path" --tab-title "$title" >/dev/null 2>&1
        return $status
    end

    if test -S /tmp/mykitty
        command kitty @ --to unix:/tmp/mykitty launch --type=tab --cwd "$path" --tab-title "$title" >/dev/null 2>&1
        return $status
    end

    echo "workspace_kitty_tab_open: no Kitty remote-control socket found" >&2
    return 1
end
