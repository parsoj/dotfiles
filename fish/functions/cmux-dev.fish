function cmux-dev --description 'launch the cmux DEV (workspace-switch-lag) build'
    set -l app '/Users/jeff/Library/Developer/Xcode/DerivedData/cmux-workspace-switch-lag/Build/Products/Debug/cmux DEV workspace-switch-lag.app'

    if not test -d "$app"
        echo "cmux-dev: app not found at:" >&2
        echo "  $app" >&2
        echo "Rebuild the workspace-switch-lag scheme in Xcode, or update the path in (status filename)." >&2
        return 1
    end

    # Launch via `open` (launchd) rather than exec'ing the binary, so the app
    # gets a clean environment. Running the binary directly from inside a
    # Claude Code session leaks CLAUDE_CODE_CHILD_SESSION=1 into every pane,
    # which silently disables session transcripts / --resume.
    open "$app"
end
