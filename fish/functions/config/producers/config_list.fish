# @inputs none
function config_list --description "list curated files under ~/.config (skips caches, logs, installed extensions)"
    find -L ~/.config -maxdepth 3 -type f \
        -not -path "*/extensions/*" \
        -not -path "*/node_modules/*" \
        -not -path "*/.git/*" \
        -not -path "*/cache/*" \
        -not -path "*/Cache/*" \
        -not -path "*/logs/*" \
        -not -path "*/*history*"
end
