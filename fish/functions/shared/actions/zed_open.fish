# @inputs    path:string
# @runs-in   background
function zed_open --argument-names path --description "open path in zed"
    test -n "$path"; or return 1
    zed $path
end
