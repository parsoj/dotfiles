set -q FZF_TMUX_HEIGHT; or set -U FZF_TMUX_HEIGHT "40%"

# Theme fzf to match cmux/Ghostty automatic light/dark themes.
# Light: Seoulbones Light. Dark: Doom One.
if defaults read -g AppleInterfaceStyle >/dev/null 2>/dev/null
    set -gx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT" \
        "--color=bg:#282c34,bg+:#3f444a,selected-bg:#3f444a" \
        "--color=fg:#bbc2cf,fg+:#dfdfdf,header:#51afef,info:#46D9FF" \
        "--color=prompt:#51afef,pointer:#c678dd,marker:#98be65,spinner:#c678dd" \
        "--color=hl:#ECBE7B,hl+:#ECBE7B,border:#5B6268,label:#bbc2cf"
else
    set -gx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT" \
        "--color=bg:#e2e2e2,bg+:#cccccc,selected-bg:#cccccc" \
        "--color=fg:#555555,fg+:#4b4b4b,header:#006f89,info:#008586" \
        "--color=prompt:#0084a3,pointer:#be3c6d,marker:#487249,spinner:#7f4c7e" \
        "--color=hl:#a76b48,hl+:#be3c6d,border:#a5a0a1,label:#555555"
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
