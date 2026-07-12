function workspace_create
    set -l no_clipboard false
    set -l args

    for arg in $argv
        if test "$arg" = "--no-clipboard"
            set no_clipboard true
        else
            set -a args $arg
        end
    end

    set -l name (string join "-" $args)

    if test -z "$name"
        read -P "Workspace name: " name
    end

    if test -z "$name"
        echo "No workspace name provided. Aborting."
        return 1
    end

    set -l ws_home ~/code/repos/workspace-home
    if not test -d $ws_home
        ~/.config/scripts/workspaces/workspace_home_bootstrap
        or return 1
    end

    set -l full_path ~/code/workspaces/$name
    if test -e "$full_path"
        echo "Error: $full_path already exists." >&2
        return 1
    end

    # Workspace root is a worktree of workspace-home; branch = workspace name.
    # This is what makes claude session lookup span workspaces (see
    # ~/.config/docs/workspace-shell-repo-design.md).
    set -l branch (workspace_branch_name "$name")
    echo "Creating new workspace at: $full_path (branch: $branch)"
    git -C $ws_home worktree add -q -b "$branch" "$full_path" main
    or begin
        echo "Error: could not create workspace worktree." >&2
        echo "If branch '$branch' already exists (stale workspace?), remove it:" >&2
        echo "  git -C ~/code/repos/workspace-home branch -D '$branch'" >&2
        return 1
    end

    # Seed the manifest and commit it on the workspace branch
    jq -n --arg created (date -u +%Y-%m-%dT%H:%M:%SZ) '{created: $created, repos: []}' > "$full_path/.workspace.json"
    git -C "$full_path" add .workspace.json
    git -C "$full_path" commit -q -m "workspace: create $name"

    cd "$full_path"

    # If clipboard contains a GitHub URL, add that repo to the workspace
    if test "$no_clipboard" = false
        set -l clip (pbpaste | string trim)
        if string match -rq '^(https://github\.com/|git@github\.com:)' "$clip"
            echo "Found GitHub URL in clipboard: $clip"
            repo_add "$clip"
        end
    end

    echo "Ready."
end
