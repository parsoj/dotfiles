function kx
    set -l context (kubectl config get-contexts -o name | fzf)
    kubectl config use-context $context
end
