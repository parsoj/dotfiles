# @inputs        path:string
# @mutates-shell yes
function dir_cd --argument-names path --description "cd to path (mutates the calling shell's cwd)"
    test -n "$path"; or return 1
    cd $path
end
