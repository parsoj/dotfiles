#if status is-interactive
    # Commands to run in interactive sessions can go here
#end

fish_add_path /opt/homebrew/bin
#oh-my-posh --init --shell fish --config ~/.poshthemes/cloud-native.json | source

alias tg=terragrunt
alias tf=terraform
alias vssh="vault-ssh connect"

source /Users/Jeff.Parsons/.docker/init-fish.sh || true # Added by Docker Desktop
starship init fish | source
