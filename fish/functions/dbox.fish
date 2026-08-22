function dbox --description "Run the debug-toolbox image: fresh pod by default, or attach to an existing pod. Extra args run as a one-shot command."
    set -l image 408930492337.dkr.ecr.us-east-1.amazonaws.com/jeff-test-images:debug-toolbox

    argparse -s 'p/pod=' 'n/namespace=' 'c/container=' 'node=' 'h/help' -- $argv
    or return

    if set -q _flag_help
        echo "dbox — cluster debug toolbox (dig, nc, ping, psql, tcpdump, ...)"
        echo
        echo "Usage:"
        echo "  dbox                          new pod, interactive bash"
        echo "  dbox <cmd...>                 new pod, run cmd, exit"
        echo "  dbox -p <pod> [cmd...]        ephemeral debug container in existing pod"
        echo "  dbox -p <pod> -c <container>  target a specific container's namespaces"
        echo "  dbox --node <node> [cmd...]   debug pod on a specific node"
        echo "  dbox -n <namespace> ...       namespace for the pod (new or existing)"
        return 0
    end

    set -l ns_args
    if set -q _flag_namespace
        set ns_args -n $_flag_namespace
    end

    # default: interactive shell; with a command: run it and exit
    set -l interactive 1
    set -l cmd bash
    if test (count $argv) -gt 0
        set interactive 0
        set cmd $argv
    end

    if set -q _flag_pod
        # ephemeral debug container in an existing pod
        set -l target_args
        if set -q _flag_container
            set target_args --target $_flag_container
        else
            # default to the pod's first container so we share its net/pid view
            set -l first (kubectl get pod $_flag_pod $ns_args -o jsonpath='{.spec.containers[0].name}')
            or return
            set target_args --target $first
        end
        if test $interactive -eq 1
            kubectl debug -it $_flag_pod $ns_args --image $image $target_args -- bash
        else
            kubectl debug -i $_flag_pod $ns_args --image $image $target_args -- $cmd
        end
    else if set -q _flag_node
        # node debug pod (host namespaces, host fs at /host)
        if test $interactive -eq 1
            kubectl debug -it node/$_flag_node $ns_args --image $image -- bash
        else
            kubectl debug -i node/$_flag_node $ns_args --image $image -- $cmd
        end
    else
        # fresh standalone pod
        set -l name dbox-(random 1000 9999)
        if test $interactive -eq 1
            kubectl run $name --rm -it --restart=Never $ns_args --image $image -- bash
        else
            kubectl run $name --rm -i --restart=Never $ns_args --image $image --command -- $cmd
        end
    end
end
