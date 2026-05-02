function pick_repo --description "pick a repo under ~/code/repos and echo its absolute path"
    set -l selected (repo_list | fzf --preview "echo ~/code/repos/{}" --prompt="repo> ")
    test -n "$selected"; and echo ~/code/repos/$selected
end
