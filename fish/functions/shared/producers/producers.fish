function producers --description "list all producer function names (by filesystem layout)"
    for f in ~/.config/fish/functions/*/producers/*.fish
        basename $f .fish
    end
end
