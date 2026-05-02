function flows --description "list all flow function names (by filesystem layout)"
    for f in ~/.config/fish/functions/*/flows/*.fish
        basename $f .fish
    end
end
