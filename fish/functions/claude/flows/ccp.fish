function ccp
    set -lx CLAUDE_CONFIG_DIR $HOME/.claude-personal
    set -lx BROWSER $HOME/.config/scripts/launchers/open-chrome-personal
    if not claude auth status 2>/dev/null | jq -e '.loggedIn == true' >/dev/null 2>&1
        claude auth login; or return 1
    end
    claude -c; or claude
end
