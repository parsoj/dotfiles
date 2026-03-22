set -q FZF_TMUX_HEIGHT; or set -U FZF_TMUX_HEIGHT "40%"

# Theme fzf based on macOS dark/light mode
# Dark: Catppuccin Frappe | Light: Nord Light
if defaults read -g AppleInterfaceStyle &>/dev/null
    set -gx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT" \
        "--color=bg+:#414559,bg:#303446,spinner:#F2D5CF,hl:#E78284" \
        "--color=fg:#C6D0F5,header:#E78284,info:#CA9EE6,pointer:#F2D5CF" \
        "--color=marker:#BABBF1,fg+:#C6D0F5,prompt:#CA9EE6,hl+:#E78284" \
        "--color=selected-bg:#51576D,border:#737994,label:#C6D0F5"
else
    set -gx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT" \
        "--color=bg+:#c2d0e7,bg:#e5e9f0,spinner:#398eac,hl:#3b6ea8" \
        "--color=fg:#60728c,header:#3b6ea8,info:#9a7500,pointer:#398eac" \
        "--color=marker:#398eac,fg+:#3b4252,prompt:#9a7500,hl+:#3b6ea8"
end
set -q FZF_LEGACY_KEYBINDINGS; or set -U FZF_LEGACY_KEYBINDINGS 1
set -q FZF_DISABLE_KEYBINDINGS; or set -U FZF_DISABLE_KEYBINDINGS 0
set -q FZF_PREVIEW_FILE_CMD; or set -U FZF_PREVIEW_FILE_CMD "head -n 10"
set -q FZF_PREVIEW_DIR_CMD; or set -U FZF_PREVIEW_DIR_CMD "ls"

if test "$FZF_DISABLE_KEYBINDINGS" -ne 1
    if test "$FZF_LEGACY_KEYBINDINGS" -eq 1
        bind \ct '__fzf_find_file'
        bind \cr '__fzf_reverse_isearch'
        bind \ec '__fzf_cd'
        bind \eC '__fzf_cd --hidden'
        bind \cg '__fzf_open'
        bind \co '__fzf_open --editor'

        if ! test "$fish_key_bindings" = fish_default_key_bindings
            bind -M insert \ct '__fzf_find_file'
            bind -M insert \cr '__fzf_reverse_isearch'
            bind -M insert \ec '__fzf_cd'
            bind -M insert \eC '__fzf_cd --hidden'
            bind -M insert \cg '__fzf_open'
            bind -M insert \co '__fzf_open --editor'
        end
    else
        bind \co '__fzf_find_file'
        bind \cr '__fzf_reverse_isearch'
        bind \ec '__fzf_cd'
        bind \eC '__fzf_cd --hidden'
        bind \eO '__fzf_open'
        bind \eo '__fzf_open --editor'

        if ! test "$fish_key_bindings" = fish_default_key_bindings
            bind -M insert \co '__fzf_find_file'
            bind -M insert \cr '__fzf_reverse_isearch'
            bind -M insert \ec '__fzf_cd'
            bind -M insert \eC '__fzf_cd --hidden'
            bind -M insert \eO '__fzf_open'
            bind -M insert \eo '__fzf_open --editor'
        end
    end

    if not bind --user \t >/dev/null 2>/dev/null
        if set -q FZF_COMPLETE
            bind \t '__fzf_complete'
            if ! test "$fish_key_bindings" = fish_default_key_bindings
                bind -M insert \t '__fzf_complete'
            end
        end
    end
end

function _fzf_uninstall -e fzf_uninstall
    bind --user \
        | string replace --filter --regex -- "bind (.+)( '?__fzf.*)" 'bind -e $1' \
        | source

    set --names \
        | string replace --filter --regex '(^FZF)' 'set --erase $1' \
        | source

    functions --erase _fzf_uninstall
end
