# @inputs    path:string
# @runs-in   background
function tmux_window_create_in --argument-names path --description "create a new tmux window with cwd at path"
    test -n "$path"; or return 1
    tmux new-window -n (basename $path) -c $path
end
