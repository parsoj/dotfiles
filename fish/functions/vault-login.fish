function vault-login --description 'Vault login via Okta OIDC'
     vault login -method=oidc -path=okta $argv; 
end
