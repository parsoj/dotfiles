#if status is-interactive
# Commands to run in interactive sessions can go here
#end

alias rrr="source ~/.config/fish/config.fish"
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

# Auto-register every subdirectory under functions/ on $fish_function_path so
# nested feature/role folders autoload. See ~/.config/fish/AGENTS.md.
for dir in ~/.config/fish/functions/**/
    if not contains -- $dir $fish_function_path
        set -p fish_function_path $dir
    end
end

envsource ~/.secret_env_vars

# Selects the adapter used by _lib_terminal_window. Override per-machine if
# you switch terminal apps. See ~/.config/fish/AGENTS.md.
set -gx FISH_TERMINAL ghostty

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

################################################################################
# git aliases (functions are autoloaded from functions/git/)

alias gd="git difftool"
alias gco="git checkout"
alias gtc="gt create"

################################################################################
# Workspaces aliases (functions are autoloaded from functions/workspaces/)

alias wr=workspace_root_cd

alias wd=cd_workspace_directory
alias wf=open_workspace_file
alias dd=cd_cwd_child_directory
alias df=open_cwd_child_file
alias gw=go_to_workspace
alias gr=open_repo
alias grt="cd ~/code/repos/Tennr"
alias war=repo_add
alias wab="repo_add odd-bits"
alias wsc=workspace_create  # was `wc`, which shadowed /usr/bin/wc
alias wrn=workspace_rename

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
