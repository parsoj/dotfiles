function _lib_meta --description "[internal] read '# @<key> <value>' header from a function's source file"
    set -l fn $argv[1]
    set -l key $argv[2]
    test -n "$fn" -a -n "$key"; or return 1
    set -l file (functions --details $fn 2>/dev/null)
    test -f "$file"; or return 1

    while read -l line
        if set -l m (string match -r "^#\s*@$key\s+(.+)\$" -- $line)
            echo $m[2]
            return 0
        end
    end <$file
    return 1
end
