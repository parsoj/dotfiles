# Kitty Quick Terminal Setup

## Core plan

Use **skhd + kitty's built-in `quick-access-terminal`** as the global macOS popup-terminal system.

We are not using Ghostty, Raycast, Hammerspoon, Karabiner, Keyboard Maestro, Shortcuts.app, or AppleScript wrappers for this path unless we explicitly reopen alternatives later.

## Key facts learned

### `kitty.conf` keymaps are not global

A kitty config line like this:

```conf
map cmd+space ...
```

only works while kitty is focused. A global macOS hotkey needs a global hotkey daemon/layer. For this setup, that layer is `skhd`.

### `cmd - space` may not be enough

On this machine/macOS setup, `Cmd+Space` may arrive as either:

```text
cmd - space   # physical Space, keycode 0x31
cmd - 0xB1    # Spotlight-style keycode path
0xB1          # sometimes observed without cmd modifier
```

So the `skhd` binding should usually include all three variants.

### `--detach` did not work here

Kitty exposes:

```sh
kitten quick-access-terminal --detach
```

but on this machine it exited without leaving a live visible quick-access popup. Plain shell backgrounding worked:

```sh
/Applications/kitty.app/Contents/MacOS/kitten quick-access-terminal ... >/tmp/kitty-quick-access-skhd.log 2>&1 &
```

So current `skhd` bindings use shell backgrounding rather than kitty's `--detach` option.

### Quick-access terminals are keyed by instance group

`quick-access-terminal` uses an instance group. The default group is:

```text
quick-access
```

Repeated invocations with the same instance group reuse/toggle the same popup. This is useful for persistent scratch terminals, but bad if unrelated workflows accidentally share the same shell state.

Therefore: **use a separate `--instance-group` per workflow.**

Examples:

```text
launcher        # Cmd+Space app/function launcher
scratch         # persistent scratch terminal
python-repl     # persistent Python REPL
open-repo       # repo picker
capture         # one-shot capture command
```

## Current launcher design

`Cmd+Space` is the launcher workflow. It should not share the default quick-access instance with other popup terminal workflows.

Planned/current shape:

```sh
cmd - space: /Applications/kitty.app/Contents/MacOS/kitten quick-access-terminal --instance-group launcher /Users/jeff/.config/kitty/quick-access-launcher.sh >/tmp/kitty-quick-access-skhd.log 2>&1 &
cmd - 0xB1: /Applications/kitty.app/Contents/MacOS/kitten quick-access-terminal --instance-group launcher /Users/jeff/.config/kitty/quick-access-launcher.sh >/tmp/kitty-quick-access-skhd.log 2>&1 &
0xB1: /Applications/kitty.app/Contents/MacOS/kitten quick-access-terminal --instance-group launcher /Users/jeff/.config/kitty/quick-access-launcher.sh >/tmp/kitty-quick-access-skhd.log 2>&1 &
```

`quick-access-launcher.sh` runs the launcher executable directly and then exits. This intentionally avoids starting fish just to resolve the `l` alias. For app launches, this makes the launcher popup terminate after selection, so the next `Cmd+Space` creates a fresh launcher popup and runs the launcher again.

Note: `kitty/quick-access-launcher.conf` exists as an experiment for allowing `Esc` to reach fzf before kitty hides the popup. It is not currently used in the hot path because passing an explicit config felt slightly slower. Current behavior uses the default quick-access config, so the kitty-level Esc mapping may hide the popup before fzf exits.

Tradeoff:

- Pro: `Cmd+Space` reliably means "run `l`".
- Pro: launcher state does not leak into other popup terminal workflows.
- Con: next invocation pays startup cost again.

## FZF layout fix

Global fzf config uses a partial-height picker:

```fish
FZF_DEFAULT_OPTS="--height 40% ..."
```

That made the `Launch >` prompt sit in the middle of the kitty quick terminal. The launcher scripts now strip only the global `--height ...` option so this picker uses the full terminal height and puts the prompt at the bottom.

Files:

```text
scripts/launchers/launch_app_or_function
scripts/launchers/launch_app_or_function.fish
```

## Startup latency: likely sources

If `Cmd+Space` feels laggy, likely cost centers are:

1. `skhd` invoking a shell command
2. launching `kitten quick-access-terminal`
3. kitty quick-access helper creating an OS window
4. fish startup/config loading where still needed, especially for function enumeration
5. generating the launcher list
6. rendering fzf

`skhd` itself is probably not the main source unless even trivial bindings feel slow.

## Strategies to improve launch time

### 1. Keep workflow instance groups separate

Do this regardless of performance work:

```sh
--instance-group launcher
--instance-group scratch
--instance-group python-repl
```

This prevents one workflow from reusing another workflow's shell state.

### 2. Use persistent instance groups where persistence is desired

For a scratch terminal or REPL, keep the shell alive and just toggle visibility:

```text
hotkey → show/hide existing group → shell state persists
```

This is fastest after first launch.

### 3. Use ephemeral groups for one-shot tasks

For launchers/capture commands, let the command exit and close the popup:

```text
hotkey → create group → run command → command exits → popup gone
```

This gives predictable behavior but pays startup on each invocation.

### 4. Make the launcher script thinner

Current launcher setup may include extra shell startup and environment repair. A faster launcher should:

- set only required environment variables
- avoid debug logging on the hot path
- avoid command probing like `command -v ...`
- avoid nested shells where possible
- use `exec` where possible

### 5. Cache launcher producers

The launcher can cache each producer independently. Current cache:

```text
~/.cache/launcher/fish-functions.tsv
```

Refresh command:

```sh
launcher_cache_refresh
```

`rrr` also refreshes the launcher cache after reloading fish config:

```fish
function rrr --description 'reload fish config and launcher cache'
    source ~/.config/fish/config.fish
    launcher_cache_refresh >/dev/null
end
```

This avoids running `fish -c 'functions'` on every launcher invocation. Timing improved pre-fzf list generation from roughly `120–180ms` to `20–40ms`.

Future possible caches:

- `/Applications` and `/System/Applications` scan results
- a combined prebuilt launcher index
- role-specific producers if the launcher grows beyond apps/functions

### 6. Avoid extra fish startup

Fish interactive startup can be expensive. Options:

- run less code in `config.fish` for quick-access launcher contexts
- set an environment variable like `KITTY_QUICK_ACCESS_LAUNCHER=1` and have fish config skip expensive startup sections
- avoid `fish -ic 'l'` in the hot path
- run the launcher executable directly where possible
- use `fish -c` instead of `fish -ic` if fish is still needed
- make `l` a real executable script rather than an alias/function that requires interactive fish

### 7. Prewarm a dedicated launcher instance

Potential future approach:

```text
login/session start → create hidden launcher instance → keep fzf/list ready
Cmd+Space → reveal already-warm launcher
```

Hard part: kitty's built-in quick-access terminal does not provide a simple "run this command every time the window is shown" hook. A loop-based launcher could work:

```text
while true: run l; after selection reopen l
```

With `hide_on_focus_loss yes`, launching an app may hide the popup while the next fzf is already ready. Cancel behavior would need careful handling.

### 8. Pool of preloaded popup terminals

Possible but more custom:

```text
preload hidden popup-1, popup-2, popup-3
hotkey picks idle popup and injects command
```

This likely requires kitty remote control, worker shells, and state tracking. Defer until simpler approaches are proven insufficient.

### 9. Custom kitty remote-control popup fallback

If built-in quick-access remains too slow, use an already-running kitty process:

```sh
kitty @ --to unix:/tmp/mykitty launch --type=os-window ...
```

Current kitty remote-control config:

```conf
allow_remote_control yes
listen_on unix:/tmp/mykitty
```

This can be fast when a normal kitty instance is already running, but it is more custom than the official quick-access kitten.

## Non-goals for now

Do not pursue unless explicitly revisiting alternatives:

- Ghostty global quick terminal
- Raycast
- Hammerspoon
- Karabiner
- Keyboard Maestro
- Shortcuts.app
- AppleScript keystroke wrappers
