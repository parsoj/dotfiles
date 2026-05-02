function kns
    set -l target_namespace (kubectl get ns -o custom-columns=NAME:.metadata.name --no-headers | fzf)
    kubectl config set-context --current --namespace=$target_namespace
end
