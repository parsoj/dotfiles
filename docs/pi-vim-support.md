# Pi Vim Support

## Current direction

We want reliable Vim-style editing in Pi without breaking Pi-native controls like agent interrupt/abort.

## Trial order

1. **Trying now:** [`pi-vimmode`](https://github.com/pekochan069/pi-vimmode)
   - Installed with: `pi install npm:pi-vimmode`
   - Reason: broadest feature surface; supports visual modes, Ex commands, registers, marks/macros, search, prompt-native text objects, and recovery/toggle commands.
   - Watch closely for complexity/regressions around `Esc`, `Ctrl-C`, `Enter`, autocomplete, and Pi interrupt behavior.

2. **On deck / fallback:** [`@burneikis/pi-vim`](https://github.com/burneikis/pi-vim)
   - Install: `pi install npm:@burneikis/pi-vim`
   - Reason: strong Vim operator/text-object support with a narrower, more editor-focused scope.
   - Looks like the best fallback if `pi-vimmode` feels too heavy or interferes with Pi behavior.

## Existing local implementation

Removed local extension:

```text
~/.pi/agent/extensions/vim.ts
```

This appeared custom/local, not a third-party package. It swallowed `Esc` in normal mode, which prevented Pi's native `app.interrupt` from firing. It has been deleted before testing packaged alternatives.

## Key requirement

Pi native interrupt must still work:

- Native binding: `app.interrupt` → `escape`
- Current config also includes `ctrl+x`
- A Vim extension should delegate `Esc` to Pi from normal mode, or otherwise provide a reliable abort path.
