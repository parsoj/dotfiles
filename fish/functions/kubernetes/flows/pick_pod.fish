function pick_pod
    set -l pod_name (kubectl get pods -o custom-columns=NAME:.metadata.name --no-headers | fzf)
    echo $pod_name
end
