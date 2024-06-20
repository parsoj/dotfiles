function authme
    if not set -q VAULT_ADDR
        echo "VAULT_ADDR environment variable is not set. Please set it and try again."
        return 1
    end

    # set VAULT_TOKEN (grep -w $VAULT_ADDR ~/.vault-tokens-stash | awk '{print $2}' | tail -n 1)

    # if test -n "$VAULT_TOKEN"
    #     echo "Found token in stash for the current VAULT_ADDR."
    # end

    # if not vault token lookup >/dev/null
    #     echo "Valid token not found - Logging in again."
    #     set NEW_VAULT_TOKEN (vault login -method=okta username=Jeff.Parsons -format=json | jq -r .auth.client_token)
    #     set -gx VAULT_TOKEN $NEW_VAULT_TOKEN

    #     # Inform the user that we're writing the new token to the stash
    #     echo "Writing new token to stash."

    #     # Update entry in .vault-tokens-stash
    #     sed -i '' "/^$VAULT_ADDR/d" ~/.vault-tokens-stash
    #     echo "$VAULT_ADDR $NEW_VAULT_TOKEN" >>~/.vault-tokens-stash
    # else
    #     echo "Current Vault token is valid."
    # end

    vault login -method=okta username=Jeff.Parsons

    echo "Checking AWS credentials..."
    if not aws sts get-caller-identity >/dev/null
        echo "Invalid AWS credentials. Running \"dbl-aws-get-creds\"..."
        dbl-aws-get-creds
    else
        echo "Current AWS credentials are valid."
    end
end
