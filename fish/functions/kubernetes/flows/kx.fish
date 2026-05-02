function kx --description "pick a k8s context and switch to it"
    set -l ctx (k8s_context_list | fzf --prompt="context> ")
    test -n "$ctx"; and kubectl_set_cluster $ctx
end
