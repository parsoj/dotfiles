# @inputs      path:string
# @destructive no
# @runs-in     terminal
function config_open --argument-names path --description "open a config file in nvim (current tty)"
    test -n "$path"; or return 1
    test -e "$path"; or begin
        echo "config_open: $path does not exist" >&2
        return 1
    end
    nvim $path
end
