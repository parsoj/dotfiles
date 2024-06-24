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



function check_vault_token
    vault token lookup >/dev/null 2>&1
    return $status
end

function vault_login
    vault login -field=token -method=okta username=Jeff.Parsons
    # return $login_output
end

function vl
    if test (count $argv) -ne 1
        echo -e "\nError: vl function only accepts one argument (the environment name)"
        return 1
    end

    set -lx environment_name (string trim -r "$argv[1]")
    set -lx all_environments $all_environments

    if test -z "$environment_name"
        echo -e "\nEnvironment must be specified as an argument (dev, sre, ...)"
        return 1
    end

    # Parse the environment's properties from the JSON data
    set -lx environment_properties (echo $all_environments | jq -r ".$environment_name | to_entries | .[] | .key + \" \" + .value")

    set -lx property $environment_properties[1]
    set -lx key (echo $property | cut -d' ' -f1)
    set -lx value (echo $property | cut -d' ' -f2-)

    echo "looking up vault url for \"$environment_name\""
    if test -z "$value"
        echo -e "\nCould not find property $key for environment $environment_name"
        return 1
    end

    echo "found vault url: $value"

    set -gx $key $value


    if not curl --output /dev/null --silent --head --fail --max-time 3 $VAULT_ADDR
        echo -e "\nVault isn't reachable - is the VPN connected? "
        return 1
    end

    # authme # Call to authme function

    # vault login -method=okta username=Jeff.Parsons
    echo "first, lets unset VAULT_TOKEN..."
    set -e VAULT_TOKEN

    # Call the vault-token-helper and capture the output
    echo "checking cache for vault token..."
    set token (vault-token-helper get)

    # Check if the token is empty
    if test -z "$token"
        echo "token not found. logging in"
        # If the token is empty, call vault login with the specified method and username
        set -Ux VAULT_TOKEN (vault_login)
    else
        echo "token found in cache"
        set -Ux VAULT_TOKEN "$token"

        echo "checking if token is still valid..."
        check_vault_token
        if test $status -ne 0
            echo "vault token is no longer valid. Logging in...."
            set -Ux VAULT_TOKEN (vault_login)
        else
            echo "token is still valid."

            echo "Done."
        end
    end

end



function _vl_complete
    set -lx environments $all_environments
    set -lx environment_names (echo $environments | jq -r 'keys | .[]')
    for environment_name in $environment_names
        #complete -c vl -f -a "$environment_name"
        #complete -c vl -n 'count (commandline -opc) < 2' -f -a "$environment_name"
        complete -c vl --no-files -n "not __fish_seen_subcommand_from $environment_names" -f -a "$environment_name"
    end
    complete -c vl --no-files
end

_vl_complete
