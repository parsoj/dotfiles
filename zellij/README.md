# Zellij setup

This is a terminal-workspace experiment: Zellij gives the persistent panes/tabs, and `fzf` provides the Helm/Ivy-style command popup.

## Start

```sh
zellij
```

The default layout opens:

- a left Yazi file-explorer sidebar (`bin/zj-file-sidebar`)
- the main shell/editor area
- Zellij's built-in status bar

## Main bindings

- `Alt-Space` opens the fzf command palette (`bin/zj-palette`) as a floating pane.
- `Ctrl-Space Space` or `Ctrl-Space l` runs your fish `l` command in a floating pane.

Note: literal `Space Space` cannot be safely captured by Zellij without stealing normal spaces from the shell, so `Ctrl-Space` is the non-invasive Spacemacs-style leader.

Palette entries include:

- `action:grep` — ripgrep + fzf, then open result in `$EDITOR`
- `action:new tab`
- `action:sessions`
- `action:lazygit` when installed
- workspace/repo directories as new tabs
- files in the current directory

Existing useful Zellij bindings in `config.kdl`:

- `Alt-h/j/k/l` focus panes
- `Alt-1..9` jump tabs
- `Ctrl-p` pane mode, then `r`/`d` split right/down, `f` fullscreen
- `Ctrl-t` tab mode
- `Ctrl-e` built-in file picker
- `Ctrl-Space Space` run fish `l`
