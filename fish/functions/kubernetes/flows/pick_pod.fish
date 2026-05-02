function pick_pod --description "pick a pod from the current namespace and echo its name"
    set -l pod (k8s_pod_list | fzf --prompt="pod> ")
    test -n "$pod"; and echo $pod
end
