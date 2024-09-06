function kubectl_set_namespace --description 'Set Kubernetes namespace'
    if test (count $argv) = 1
        kubectl config set-context --current --namespace=$argv[1]
    else
        echo "Usage: kubectl_set_namespace <namespace>"
    end
end

function __fish_get_current_cluster --description 'Get the name of the current Kubernetes cluster'
    kubectl config current-context
end

function __fish_print_kubernetes_namespaces --description 'Print a list of all Kubernetes namespaces'
    set -l current_cluster (__fish_get_current_cluster)
    set -l cache_key "__kubectl_namespaces_cache_$current_cluster"
    set -l expiry_key "__kubectl_namespaces_expiry_$current_cluster"
    set -l current_time (date +%s)

    if not set -q $cache_key
        set -g $cache_key ""
    end
    if not set -q $expiry_key
        set -g $expiry_key 0
    end

    if test -z "$$cache_key" -o $current_time -ge $$expiry_key
        set -g $cache_key (command kubectl get namespaces -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
        # Set cache to expire after 5 minutes (300 seconds)
        set -g $expiry_key (math $current_time + 300)
    end

    printf '%s\n' $$cache_key
end

complete -f -c kubectl_set_namespace -a '(__fish_print_kubernetes_namespaces)'
