function k8s_context_list --description "list configured k8s contexts"
    kubectl config get-contexts -o name
end
