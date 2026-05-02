function kx --description "pick a k8s context and switch to it"
    set -l ctx (k8s_context_list | fzf --prompt="context> ")
    test -n "$ctx"; and k8s_context_set $ctx
end
