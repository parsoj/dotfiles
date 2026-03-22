# Neovim Configuration

This Neovim configuration is based on [LazyVim for Ambitious Developers](https://lazyvim-ambitious-devs.phillips.codes/) by Dusty Phillips.

## Structure

Following the LazyVim starter template structure:

```
~/.config/nvim/
├── init.lua                    # Entry point (loads config.lazy)
├── lua/
│   ├── config/
│   │   ├── autocmds.lua       # Custom autocommands
│   │   ├── keymaps.lua        # Custom key mappings
│   │   ├── lazy.lua           # Plugin manager bootstrap
│   │   └── options.lua        # Neovim options
│   └── plugins/
│       ├── example.lua        # Example plugin config (disabled)
│       └── lang.lua           # Language support extras
```

## Adding Plugins

Create new `.lua` files in `lua/plugins/` - they are auto-loaded by lazy.nvim.

To enable LazyVim extras, use imports:
```lua
return {
  { import = "lazyvim.plugins.extras.lang.python" },
}
```

## Current Setup

- **Clipboard**: System clipboard sync enabled (`unnamedplus`)
- **Languages**: Python and TypeScript extras enabled via `lua/plugins/lang.lua`

## References

- [LazyVim Documentation](https://lazyvim.github.io/)
- [LazyVim Extras List](https://lazyvim.github.io/extras)
- [lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
