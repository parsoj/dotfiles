# @destructive yes
function git_hard_reset
    git reset --hard
    git clean -fd
    git status
end
