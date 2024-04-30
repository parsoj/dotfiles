set -U all_environments '
{
    "prod": {
        "VAULT_ADDR": "https://vault.mgmt.prod.dreambox.net",
        "AWS_PROFILE": "dbl-prod-sre"
    },
    "rpprod": {
        "AWS_PROFILE": "dbl-rpprod-sre"
    },
    "shared": {
        "VAULT_ADDR": "https://vault.mgmt.shared.dreambox.net",
        "AWS_PROFILE": "dbl-shared-sre"
    },
    "stage": {
        "VAULT_ADDR": "https://vault.mgmt.stage.dreambox.net",
        "AWS_PROFILE": "dbl-stage-sre"
    },
    "sre": {
        "VAULT_ADDR": "https://vault.mgmt.sre.dreambox.net",
        "AWS_PROFILE": "dbl-sre-sre"
    },
    "dev": {
        "VAULT_ADDR": "https://vault.mgmt.dev.dreambox.net",
        "AWS_PROFILE": "dbl-dev-sre"
    }
}
'

function cl
    if test (count $argv) -ne 1
        echo "Error: cl function only accepts one argument (the environment name)"
        return 1
    end

    set -lx environment_name (string trim -r "$argv[1]")
    set -lx all_environments $all_environments

    if test -z "$environment_name"
        echo "Environment must be specified as an argument (dev, sre, ...)"
        return 1
    end

    # Parse the environment's properties from the JSON data
    set -lx environment_properties (echo $all_environments | jq -r ".$environment_name | to_entries | .[] | .key + \" \" + .value")

    for property in $environment_properties
        set -lx key (echo $property | cut -d' ' -f1)
        set -lx value (echo $property | cut -d' ' -f2-)

        if test -z "$value"
            echo "Could not find property $key for environment $environment_name"
            return 1
        end

        set -gx $key $value
    end

    authme # Call to authme function
end

function _cl_complete
    set -lx environments $all_environments
    set -lx environment_names (echo $environments | jq -r 'keys | .[]')
    for environment_name in $environment_names
        #complete -c cl -f -a "$environment_name"
        #complete -c cl -n 'count (commandline -opc) < 2' -f -a "$environment_name"
        complete -c cl --no-files -n "not __fish_seen_subcommand_from $environment_names" -f -a "$environment_name"
    end
    complete -c cl --no-files
end

_cl_complete
