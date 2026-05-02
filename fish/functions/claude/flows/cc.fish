function cc
    set -lx CLAUDE_CONFIG_DIR $HOME/.claude
    set -lx BROWSER $HOME/.config/scripts/launchers/open-chrome-work
    if not claude auth status 2>/dev/null | jq -e '.loggedIn == true' >/dev/null 2>&1
        claude auth login --sso; or return 1
    end
    claude -c; or claude
end
