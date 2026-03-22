function pick_repo
    find ~/code/repos -maxdepth 3 -name .git -type d | while read gitdir
        dirname "$gitdir"
    end | string replace "$HOME/code/repos/" "" | sort | fzf --preview "echo ~/code/repos/{}" | read -l selected
    if test -n "$selected"
        echo ~/code/repos/$selected
    end
end
