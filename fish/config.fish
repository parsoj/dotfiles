#if status is-interactive
# Commands to run in interactive sessions can go here
#end

alias rrr="source ~/.config/fish/config.fish"

fish_add_path /opt/homebrew/bin
fish_add_path (brew --prefix python)/libexec/bin

# DBL stuff

# for f in /opt/homebrew/opt/dbl-dev-workstation-tools/share/*.sh
#     if test -r "$f"
#         source "$f"
#     end
# end

#oh-my-posh --init --shell fish --config ~/.poshthemes/cloud-native.json | source
#

fish_vi_key_bindings

alias gs="git status"

alias tg=terragrunt
alias tf=terraform
alias vssh="vault-ssh connect"

alias vv=nvim
alias kc=kubectl

alias py=ipython
alias q=exit

#source /Users/Jeff.Parsons/.docker/init-fish.sh || true # Added by Docker Desktop
direnv hook fish | source
STARSHIP_CONFIG=~/.config/starship/starship.toml starship init fish | source
#starship init fish | source



#set -x PATH $HOME/.luaver/lua/5.1/bin $PATH
#set -x LUA_PATH "$HOME/.luaver/lua/5.1/share/lua/5.1/?.lua;$HOME/.luaver/lua/5.1/share/lua/5.1/?/init.lua;./?.lua;$HOME/.luaver/lua/5.1/lib/lua/5.1/?.lua;$HOME/.luaver/lua/5.1/lib/lua/5.1/?/init.lua"
#set -x LUA_CPATH "$HOME/.luaver/lua/5.1/lib/lua/5.1/?.so;./?.so"
#set -x LUAROCKS_CONFIG "$HOME/.luaver/lua/5.1/luarocks/config-5.1.lua"

fish_add_path ~/.config/scripts/launchers/

################################################################################
# Workspaces settings

# load workspaces functions
set -U fish_function_path $fish_function_path ~/.config/fish/functions/workspaces

alias wr=cd_workspace_root

alias ff=open_workspace_file
alias fd=open_cwd_child_file
alias cdw=cd_workspace_directory
alias cdd=cd_cwd_child_directory
alias ww=switch_to_workspace


################################################################################



# if set -q ZELLIJ
# else
#     zellij
# end

# Added by Windsurf
fish_add_path /Users/jeff/.codeium/windsurf/bin
