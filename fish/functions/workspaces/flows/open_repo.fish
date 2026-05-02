function open_repo
    set -l repo (pick_repo)
    test -n "$repo"; and dir_cd $repo
end
