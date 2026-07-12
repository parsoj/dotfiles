#if status is-interactive
# Commands to run in interactive sessions can go here
#end

function rrr --description 'reload fish config and launcher cache'
    source ~/.config/fish/config.fish
    launcher_cache_refresh >/dev/null
end
alias cnf="cd ~/.config"
alias vo="nvim (fzf)"
alias watch=entr
alias ib=inbox_send
alias wib=work_inbox_send

# Individual script paths (commented out):
#fish_add_path ~/.config/scripts/launchers/
#fish_add_path ~/.config/scripts/capture/

# Doom Emacs CLI (`doom sync`, `doom doctor`, etc.).
fish_add_path ~/.emacs.d/bin

# Default Node version. Keep this static for faster shell startup instead of
# sourcing nvm on every new fish shell.
fish_add_path ~/.nvm/versions/node/v24.12.0/bin

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

# Fish autosuggestions render incorrectly in Emacs vterm on this setup: the
# history suggestion can appear to be accepted before newly typed characters
# (e.g. typing "mv" ends up after the grey suggestion). Disable only inside
# vterm; keep autosuggestions in normal terminal emulators.
if set -q INSIDE_EMACS; and string match -q "*vterm*" -- $INSIDE_EMACS
    set -g fish_autosuggestion_enabled 0
end

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

# rendered markdown preview pane in current cmux workspace (live-reloads)
alias mdp="cmux markdown open"

# open a file in nvim in a new split pane in the current cmux workspace
function vp
    set -l out (cmux new-pane --direction right --focus true)
    or begin
        echo "vp: cmux new-pane failed: $out" >&2
        return 1
    end
    set -l surface (string match -r 'surface:\S+' -- "$out")
    if test -z "$surface"
        echo "vp: could not parse surface from: $out" >&2
        return 1
    end
    if set -q argv[1]
        cmux send --surface $surface -- "nvim "(string escape -- (path resolve -- $argv[1]))
        cmux send-key --surface $surface enter
    end
end

alias vv=nvim
alias k=kubectl
alias p=pnpm

alias py=ipython
alias q=exit

#source /Users/Jeff.Parsons/.docker/init-fish.sh || true # Added by Docker Desktop
direnv hook fish | source
if not set -q QUICK_TERM
    # Per-host starship hostname color: hot = personal, cool = work.
    # Regenerates a cached copy of starship.toml with `hostcolor` swapped.
    set -l ss_base ~/.config/starship/starship.toml
    set -l ss_color
    switch (hostname -s)
        case TNR-726TG622
            set ss_color "#f38ba8" # red — personal air
        case DWK9HLXCJC-jeff
            set ss_color "#74c7ec" # sapphire — tennr mbp
    end
    if test -n "$ss_color"; and test -f $ss_base
        set -l ss_gen ~/.cache/starship/starship-host.toml
        if not test -f $ss_gen
            or test $ss_base -nt $ss_gen
            or not grep -q "hostcolor = \"$ss_color\"" $ss_gen
            mkdir -p ~/.cache/starship
            sed "s/^hostcolor = .*/hostcolor = \"$ss_color\"/" $ss_base >$ss_gen
        end
        set -gx STARSHIP_CONFIG $ss_gen
    end
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
alias cw=workspace_create
alias wrn=workspace_rename

##########################################################################################

# file contents

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

# Static Homebrew environment. Avoid `eval "$(brew shellenv)"` here: it shells
# out to brew/path_helper on every new Fish shell and costs ~20–25ms.
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew
fish_add_path --prepend /opt/homebrew/bin /opt/homebrew/sbin
set -gx INFOPATH /opt/homebrew/share/info $INFOPATH

# uv
fish_add_path "/Users/jeff/.local/bin"
spur init fish | source
