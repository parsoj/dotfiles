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
    set -l cache_file "/tmp/.kubectl_namespaces_cache_$current_cluster"
    set -l current_time (date +%s)
    
    # Check if cache file exists and is less than 5 minutes old
    if test -f $cache_file
        set -l file_time (stat -f %m $cache_file 2>/dev/null; or stat -c %Y $cache_file 2>/dev/null)
        if test (math $current_time - $file_time) -lt 300
            # Cache is still valid, use it
            cat $cache_file
            return
        end
    end
    
    # Cache is expired or doesn't exist, refresh it
    command kubectl get namespaces -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | tee $cache_file
end

complete -f -c kubectl_set_namespace -a '(__fish_print_kubernetes_namespaces)'
