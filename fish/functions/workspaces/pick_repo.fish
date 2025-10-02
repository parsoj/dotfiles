function pick_repo
    ls -1 ~/code/repos | fzf --preview 'echo ~/code/repos/{}' | read -l selected
    if test -n "$selected"
        echo ~/code/repos/$selected
    end
end
