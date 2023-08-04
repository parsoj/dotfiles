function vault-ssh-env
         VAULT_ADDR=https://vault.mgmt.$1.dreambox.net vault-ssh connect $2.$3

end

function dev-ssh
         vault-ssh-env dev 10.179 $1
end

function stage-ssh
         vault-ssh-env stage 10.147 $1
end

function prod-ssh
         vault-ssh-env stage 10.136 $1
end
