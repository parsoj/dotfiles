function repo_list --description "list repos under ~/code/repos (relative paths)"
    find ~/code/repos -maxdepth 3 -name .git -type d | while read gitdir
        dirname "$gitdir"
    end | string replace "$HOME/code/repos/" "" | sort
end
