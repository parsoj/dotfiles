function actions --description "list all action function names (by filesystem layout)"
    for f in ~/.config/fish/functions/*/actions/*.fish
        basename $f .fish
    end
end
