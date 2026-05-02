# @inputs none
function config_list --description "list every file under ~/.config"
    find -L ~/.config -type f
end
