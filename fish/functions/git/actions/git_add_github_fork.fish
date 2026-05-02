function git_add_github_fork
    set -l url $argv[1]
    set -l parts (string split / $url)
    set -l name $parts[4]
    set -l branch $parts[7]
    set -l repo_url "https://github.com/$name/$parts[5].git"
    git remote add $name $repo_url
    git fetch $name
    git checkout -b $name-$branch $name/$branch
end
