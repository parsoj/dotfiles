#if status is-interactive
# Commands to run in interactive sessions can go here
#end

fish_add_path /opt/homebrew/bin
fish_add_path (brew --prefix python)/libexec/bin


# DBL stuff

# for f in /opt/homebrew/opt/dbl-dev-workstation-tools/share/*.sh
#     if test -r "$f"
#         source "$f"
#     end
# end

#oh-my-posh --init --shell fish --config ~/.poshthemes/cloud-native.json | source

alias tg=terragrunt
alias tf=terraform
alias vssh="vault-ssh connect"

#source /Users/Jeff.Parsons/.docker/init-fish.sh || true # Added by Docker Desktop
direnv hook fish | source
STARSHIP_CONFIG=~/.config/starship/starship.toml starship init fish | source
# starship init fish | source




# if set -q ZELLIJ
# else
#     zellij
# end
