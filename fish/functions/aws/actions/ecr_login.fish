function ecr_login
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 408930492337.dkr.ecr.us-east-1.amazonaws.com
end
