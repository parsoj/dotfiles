# @inputs    path:string
# @runs-in   terminal
function nvim_open --argument-names path --description "open path in nvim"
    test -n "$path"; or return 1
    nvim $path
end
