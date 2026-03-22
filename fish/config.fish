#if status is-interactive
# Commands to run in interactive sessions can go here
#end

alias rrr="source ~/.config/fish/config.fish"
alias cc="claude -c; or claude"
alias vo="vim (fzf)"
alias watch=entr
alias l=launch_app_or_function
alias ib=send_to_inbox
alias wib=send_to_work_inbox

# Individual script paths (commented out):
#fish_add_path ~/.config/scripts/launchers/
#fish_add_path ~/.config/scripts/capture/

# Recursively add all directories containing executable scripts (excluding test files)
for dir in (find ~/.config/scripts -type f -perm +111 -not -name "*test*" -print0 | xargs -0 dirname | sort | uniq)
    fish_add_path $dir
end

# Add function subdirectories to function path
set -g fish_function_path ~/.config/fish/functions/workspaces ~/.config/fish/functions/kubernetes ~/.config/fish/functions/utils $fish_function_path

envsource ~/.secret_env_vars

if status is-interactive
    set -g fish_greeting

    # Auto-start tmux in ghostty (disabled)
    # if test "$TERM_PROGRAM" = ghostty -a -z "$TMUX" -a -z "$GHOSTTY_QUICK_TERMINAL"
    #     exec tmux new-session -A -s main
    # end

    # Map this terminal's TTY to its yabai window ID (before tmux starts).
    # Claude Code notification hooks use this to focus the exact Ghostty window.
    if set -q GHOSTTY_RESOURCES_DIR; and not set -q TMUX
        set -l wid (yabai -m query --windows --window 2>/dev/null | jq -r '.id')
        if test -n "$wid" -a "$wid" != null
            mkdir -p /tmp/ghostty-yabai
            echo $wid >/tmp/ghostty-yabai/(tty | string replace -a '/' '_')
        end
    end
end

# DBL stuff

# for f in /opt/homebrew/opt/dbl-dev-workstation-tools/share/*.sh
#     if test -r "$f"
#         source "$f"
#     end
# end

#oh-my-posh --init --shell fish --config ~/.poshthemes/cloud-native.json | source
#

fish_vi_key_bindings

# alias ws="windsurf"

alias char_count="/usr/bin/wc -m"
alias word_count="/usr/bin/wc -w"
alias line_count="/usr/bin/wc -l"

# alias tg=terragrunt
alias tf=tofu
alias tfi="tofu init"
alias tfa="tofu apply"
alias tfp="tofu plan"
# alias vssh="vault-ssh connect"

alias vv=nvim
alias k=kubectl
alias p=pnpm

alias py=ipython
alias q=exit

#source /Users/Jeff.Parsons/.docker/init-fish.sh || true # Added by Docker Desktop
direnv hook fish | source
if not set -q QUICK_TERM
    starship init fish | source
end

#set -x PATH $HOME/.luaver/lua/5.1/bin $PATH
#set -x LUA_PATH "$HOME/.luaver/lua/5.1/share/lua/5.1/?.lua;$HOME/.luaver/lua/5.1/share/lua/5.1/?/init.lua;./?.lua;$HOME/.luaver/lua/5.1/lib/lua/5.1/?.lua;$HOME/.luaver/lua/5.1/lib/lua/5.1/?/init.lua"
#set -x LUA_CPATH "$HOME/.luaver/lua/5.1/lib/lua/5.1/?.so;./?.so"
#set -x LUAROCKS_CONFIG "$HOME/.luaver/lua/5.1/luarocks/config-5.1.lua"

# for dir in (find ~/.config/scripts -type f -perm +111 -not -name "*test*" -print0 | xargs -0 dirname | sort | uniq)
#     fish_add_path $dir
# end

##########################################################################################
# AWS stuff
set -gx AWS_PROFILE prod-admin

function ecr_login
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 408930492337.dkr.ecr.us-east-1.amazonaws.com
end

##########################################################################################
# workspacey stuff
#

function workspace_root
    set -l current_path (pwd)
    set -l home_path ~

    # Loop until we hit / or ~/
    while test "$current_path" != / -a "$current_path" != "$home_path"
        # Check if .workspace file exists in current directory
        if test -f "$current_path/.workspace.json"
            echo "$current_path"
            return 0
        end

        # Move up one directory
        set current_path (dirname "$current_path")
    end

    # Check the final directory (/ or ~/)
    if test -f "$current_path/.workspace.json"
        echo "$current_path"
        return 0
    end

    # If we got here, we didn't find a .workspace file
    echo "not in a workspace" >&2
    return 1
end

################################################################################
# Steampipe

function run_steampipe_service
    steampipe service stop
    steampipe service start --database-password pwd

end

################################################################################
# kubernetes

function kns
    set -l target_namespace (kubectl get ns -o custom-columns=NAME:.metadata.name --no-headers | fzf)
    kubectl config set-context --current --namespace=$target_namespace
end

function kx
    set -l context (kubectl config get-contexts -o name| fzf)
    kubectl config use-context $context

end

function pick_pod
    set -l pod_name (kubectl get pods -o custom-columns=NAME:.metadata.name --no-headers | fzf)
    echo $pod_name
end

################################################################################
# aws 

function ax
    set -gx AWS_PROFILE (aws configure list-profiles | fzf)
end

################################################################################
# git settings

alias gd="git difftool"
alias gco="git checkout"
alias gtc="gt create"

function gs
    gt ls --stack 2>/dev/null
    git status
end

function ga
    git add $argv
    git status
end

function git-hard-reset
    git reset --hard
    git clean -fd
    git status
end

function gm
    if test -z "$argv"
        echo "Error: No commit message provided." >&2
        return 1
    end

    set commit_message (string join " " $argv)

    if test (git diff --cached --name-only | line_count) -gt 0
        gt modify -c -m "$commit_message" 2>/dev/null
        or git commit -m "$commit_message"
    else
        gt modify -c -a -m "$commit_message" 2>/dev/null
        or git commit -a -m "$commit_message"
    end
end

function gms
    gm $argv
    or return 1
    gt submit --stack --draft --ai 2>/dev/null
    or echo "Graphite submit skipped (not a graphite repo)"
end

function git_add_github_fork
    set -l url $argv[1]
    set -l parts (string split / $url)
    set -l name $parts[4]
    set -l branch $parts[7]
    set -l repo_url "https://github.com/$name/$parts[5].git"
    git remote add $name $repo_url
    git fetch $name
    git checkout -b $name-$branch $name/$branch
end

################################################################################
# Workspaces settings

# load workspaces functions
#if not contains -- ~/.config/fish/functions/workspaces $fish_function_path
#    set -U fish_function_path $fish_function_path ~/.config/fish/functions/workspaces
#end

# function tw
#     create_new_workspace
#     git clone
#     git clone --depth 1 git@github.com:Tennr-Inc/Tennr.git
#     cursor ./Tennr

# end

function rr
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$git_root"
        echo "Not inside a git repository."
    else
        cd $git_root
    end
end

alias wr=cd_workspace_root

alias wd=cd_workspace_directory
alias wf=open_workspace_file
alias dd=cd_cwd_child_directory
alias df=open_cwd_child_file
alias gw=go_to_workspace
alias gr=open_repo
alias grt="cd ~/code/repos/Tennr"
alias war=add_repo
alias wab="add_repo odd-bits"
alias wc=create_new_workspace

################################################################################
# Config browsing

function con
    set -l config_file (find -L ~/.config -type f | fzf)
    if test -n "$config_file"
        nvim "$config_file"
    end
end

##########################################################################################

# file contents

function nvm
    bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR ~/.nvm
nvm use default --silent

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# pnpm
set -gx PNPM_HOME /Users/jeff/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

#string match -q "$TERM_PROGRAM" kiro and . (kiro --locate-shell-integration-path fish)

# set -U fish_user_paths /Users/jeff/.groundcover/bin $fish_user_paths

eval "$(/opt/homebrew/bin/brew shellenv)"

# uv
fish_add_path "/Users/jeff/.local/bin"
