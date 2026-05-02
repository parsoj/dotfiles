function k8s_namespace_list --description "list k8s namespaces in the current context"
    kubectl get ns -o custom-columns=NAME:.metadata.name --no-headers
end
