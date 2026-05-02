function kns --description "pick a k8s namespace and set it on the current context"
    set -l ns (k8s_namespace_list | fzf --prompt="namespace> ")
    test -n "$ns"; and kubectl_set_namespace $ns
end
