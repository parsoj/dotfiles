# @runs-in     background
function k8s_context_set --description 'Switch Kubernetes cluster'
    if test (count $argv) = 1
        kubectl config use-context $argv[1]
    else
        echo "Usage: kc <cluster-name>"
    end
end

function __fish_print_kubernetes_clusters --description 'Print a list of all Kubernetes clusters'
    kubectl config get-contexts -o name
end

complete -c k8s_context_set -f -a '(__fish_print_kubernetes_clusters)'
