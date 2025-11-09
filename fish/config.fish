#if status is-interactive
# Commands to run in interactive sessions can go here
#end

alias rrr="source ~/.config/fish/config.fish"
alias z=zed
alias cc="cd (fzf --walker dir,follow,hidden)"

# Individual script paths (commented out):
#fish_add_path ~/.config/scripts/launchers/
#fish_add_path ~/.config/scripts/capture/

# Recursively add all directories containing executable scripts (excluding test files)
for dir in (find ~/.config/scripts -type f -perm +111 -not -name "*test*" -print0 | xargs -0 dirname | sort | uniq)
    fish_add_path $dir
end

# Add function subdirectories to function path
set -g fish_function_path ~/.config/fish/functions/workspaces ~/.config/fish/functions/kubernetes $fish_function_path

envsource ~/.secret_env_vars


if status is-interactive
    set -g fish_greeting
    # Commands to run in interactive sessions can go here
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

alias char_count="wc -m"
alias word_count="wc -w"
alias line_count="wc -l"

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
starship init fish | source

#set -x PATH $HOME/.luaver/lua/5.1/bin $PATH
#set -x LUA_PATH "$HOME/.luaver/lua/5.1/share/lua/5.1/?.lua;$HOME/.luaver/lua/5.1/share/lua/5.1/?/init.lua;./?.lua;$HOME/.luaver/lua/5.1/lib/lua/5.1/?.lua;$HOME/.luaver/lua/5.1/lib/lua/5.1/?/init.lua"
#set -x LUA_CPATH "$HOME/.luaver/lua/5.1/lib/lua/5.1/?.so;./?.so"
#set -x LUAROCKS_CONFIG "$HOME/.luaver/lua/5.1/luarocks/config-5.1.lua"

# for dir in (find ~/.config/scripts -type f -perm +111 -not -name "*test*" -print0 | xargs -0 dirname | sort | uniq)
#     fish_add_path $dir
# end


##########################################################################################
# workspacey stuff
#

function workspace_root
    set -l current_path (pwd)
    set -l home_path ~

    # Loop until we hit / or ~/
    while test "$current_path" != "/" -a "$current_path" != "$home_path"
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

function add_repo_to_workspace
    set -l current_workspace (workspace_root)
    if test -z "$current_workspace"
        echo "not in a workspace" >&2
        return 1
    end

    set -l repo_path (pick_repo)
    set -l repo_name (basename "$repo_path")
    set -l workspace_name (basename "$current_workspace")
    set -l branch_name "$workspace_name"

    # Check if directory already exists in workspace
    if test -d "$current_workspace/$repo_name"
        echo "Error: $repo_name already exists in workspace at $current_workspace/$repo_name" >&2
        return 1
    end

    # Create worktree with unique branch name but standard directory name
    cd "$repo_path" && git worktree add -b "$branch_name" "$current_workspace/$repo_name"
    cd -
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
# git settings

alias gd="gt diff"
alias gco="gt checkout"
alias gtc="gt create"

function gs
    gt ls
    gt status
end

#alias ga="git add"

function ga
    gt add $argv
    gt status
end

function git-hard-reset
    gt reset --hard
    gt clean -fd
    gt status
end

alias gd="git difftool"

# function gc
#     # Check if any arguments were provided for the commit message
#     if test -z "$argv"
#         echo "Error: No commit message provided."
#         echo "Usage: gc <commit message>"
#         return 1 # Exit the function with an error status
#     end

#     # Join all arguments to form the commit message
#     set commit_message (string join " " $argv)

#     git commit -m "$commit_message"
#     git push
#     git status
# end

function gm

    # Check if any arguments were provided for the commit message
    if test -z "$argv"
        echo "Error: No commit message provided."
        echo "Usage: gts <commit message>"
        return 1 # Exit the function with an error status
    end

    set commit_message (string join " " $argv)

    # Check if anything is staged
    if test (git diff --cached --name-only | wc -l) -gt 0
        # Something is staged, commit just that
        gt modify -c -m "$commit_message"
    else
        # Nothing is staged, commit everything
        gt modify -c -a -m "$commit_message"
    end

end

function gms
    gm $argv
    gt submit --stack --draft --ai
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

alias ff=open_workspace_file
alias fd=open_cwd_child_file
alias cdw=cd_workspace_directory
alias cdd=cd_cwd_child_directory
alias ww=switch_to_workspace

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
