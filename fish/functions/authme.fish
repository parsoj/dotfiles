function authme
    echo "Checking vault token..."
    if not vault token lookup > /dev/null
        echo "Invalid or expired Vault token. Logging in again."
        vault login -method=okta username=Jeff.Parsons
    else
        echo "Current Vault token is valid."
    end

    echo "Checking AWS credentials..."
    if not aws sts get-caller-identity > /dev/null
        echo "Invalid AWS credentials. Running \"dbl-aws-get-creds\"..."
        dbl-aws-get-creds
    else
        echo "Current AWS credentials are valid."
    end
end
