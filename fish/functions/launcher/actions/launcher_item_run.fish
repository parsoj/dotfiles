# @inputs item:string
# @runs-in terminal
function launcher_item_run --argument-names item --description "run a typed launcher item"
    test -n "$item"; or return 1

    set -l tab (printf "\t")
    set -l fields (string split -m 2 -- $tab "$item")
    set -l type $fields[1]
    set -l value $fields[2]

    switch "$type"
        case APP
            open "$value"
        case FUNC
            # Run in the current fish process so shell-mutating flows, like cd-based
            # workspace pickers, can leave the terminal in the selected context.
            eval "$value"
        case '*'
            echo "launcher_item_run: unknown launcher item type: $type" >&2
            return 1
    end
end
