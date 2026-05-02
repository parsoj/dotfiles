# @destructive yes
function git-hard-reset
    git reset --hard
    git clean -fd
    git status
end
