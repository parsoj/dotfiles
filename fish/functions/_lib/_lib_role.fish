function _lib_role --description "[internal] return the role of a loaded function (= name of its parent folder), empty if unknown"
    set -l fn $argv[1]
    test -n "$fn"; or return 1
    set -l file (functions --details $fn 2>/dev/null)
    test -f "$file"; or return 1
    basename (dirname $file)
end
