#!/usr/bin/env fish

# Combine macOS apps and Fish functions into a single fuzzy finder (Fish version)
set selection (begin
    begin
        # List macOS apps with "APP:" prefix
        for dir in /Applications /System/Applications
            if test -d $dir
                find $dir -maxdepth 1 -name "*.app"
            end
        end | awk -F'/' '{print "APP:" $0 " ## " substr($NF, 1, length($NF)-4)}'

        # List Fish functions with "FUNC:" prefix
        functions | awk '{print "FUNC:" $0 " ## " $0}'
    end |
    fzf --delimiter ' ## ' --with-nth=2 --prompt='Launch > ' |
    awk -F' ## ' '{print $1}'
end)

# User cancelled the picker
if test -z "$selection"
    exit 0
end

set parsed (string split -m 1 ":" -- $selection)
set type (string trim -- $parsed[1])
set value (string trim -- $parsed[2])

switch $type
case APP
    open "$value"
case FUNC
    # Run the function inside a new interactive fish so it can leave you in-context.
    exec fish -C "$value"
end
