function kubectl_set_cluster --description 'Switch Kubernetes cluster'
    if test (count $argv) = 1
        kubectl config use-context $argv[1]
    else
        echo "Usage: kc <cluster-name>"
    end
end

function __fish_print_kubernetes_clusters --description 'Print a list of all Kubernetes clusters'
    kubectl config get-contexts -o name
end

complete -c kubectl_set_cluster -f -a '(__fish_print_kubernetes_clusters)'
