function scipenv
    set -q argv[1]; or begin; echo 'An argument is required'; return 1; end

    # Run scipctl profile use command with the input as argument
    echo "switching to S4 profile: $argv[1]"
    scipctl profile use $argv[1]

    # Extract the first token before the "-" delimiter
    set scip_class (echo $argv[1] | cut -d"-" -f1)
    echo "found class from profile name: $scip_class"

    # Call the 'cl' function with the 'scip_class' variable as argument
    echo "pointing local environment to $scip_class"
    cl $scip_class
end

function _scip_complete
    set -lx profiles (scipctl profile ls | awk '{print $1}' | grep -v '^Warning' | grep -v '^$')



    for profile in $profiles
        complete -c scipenv -f -a "$profile"
    end
end

_scip_complete