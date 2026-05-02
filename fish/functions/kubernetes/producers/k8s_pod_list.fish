function k8s_pod_list --description "list pods in the current namespace"
    kubectl get pods -o custom-columns=NAME:.metadata.name --no-headers
end
