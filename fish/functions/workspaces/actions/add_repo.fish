function add_repo
    set -l current_workspace
    begin
        workspace_root
    end 2>/dev/null | read current_workspace
    set -l input $argv[1]

    # Determine if input is a GitHub URL
    set -l is_git_url no
    if test -n "$input"; and string match -rq '^(https://github\.com/|git@github\.com:)' "$input"
        set is_git_url yes
    end

    # Outside a workspace: only git URLs are allowed
    if test -z "$current_workspace"
        if test "$is_git_url" = no
            echo "Error: not in a workspace. Pass a GitHub URL to clone a repo." >&2
            return 1
        end
    end

    # Resolve repo_path
    set -l repo_path
    if test -n "$input"
        if test "$is_git_url" = yes
            set -l org_repo (string replace -r '^https://github\.com/' '' "$input" | string replace -r '^git@github\.com:' '' | string replace -r '\.git$' '')
            set -l ssh_url "git@github.com:$org_repo.git"
            set -l repo_name (basename "$org_repo")
            set repo_path ~/code/repos/$repo_name

            if test -d "$repo_path"
                echo "Repo already cloned at $repo_path"
            else
                echo "Cloning $ssh_url into $repo_path ..."
                git clone "$ssh_url" "$repo_path"
                or return 1
            end
        else
            set repo_path ~/code/repos/$input
            if not test -d "$repo_path"
                echo "Error: repo '$input' not found at $repo_path" >&2
                return 1
            end
        end
    else
        set repo_path (pick_repo)
    end

    # If not in a workspace, we're done after cloning
    if test -z "$current_workspace"
        return 0
    end

    # Add repo to workspace as a git worktree
    set -l repo_name (basename "$repo_path")
    set -l workspace_name (basename "$current_workspace")
    set -l branch_name "$workspace_name"

    if test -d "$current_workspace/$repo_name"
        echo "Error: $repo_name already exists in workspace at $current_workspace/$repo_name" >&2
        return 1
    end

    cd "$repo_path"
    set -l worktree_dest "$current_workspace/$repo_name"

    # Try creating worktree with a new branch
    git worktree add -b "$branch_name" "$worktree_dest" 2>/tmp/add_repo_err
    or begin
        set -l err (cat /tmp/add_repo_err)
        set -l resolved false

        # Handle stale worktree registration
        if string match -q "*already registered worktree*" "$err"
            echo "$err" >&2
            read -P "Stale worktree detected. Prune and retry? [y/N] " confirm
            if test "$confirm" = "y"
                git worktree prune
                git worktree add -b "$branch_name" "$worktree_dest" 2>/tmp/add_repo_err
                and set resolved true
                or set -l err (cat /tmp/add_repo_err)
            else
                cd -
                return 1
            end
        end

        # Handle branch already exists (may occur after prune retry too)
        if test "$resolved" = false; and string match -q "*already exists*" "$err"
            echo "Branch '$branch_name' already exists." >&2
            read -P "Delete and recreate? [y/N] " confirm
            if test "$confirm" = "y"
                git worktree prune
                git branch -D "$branch_name"
                git worktree add -b "$branch_name" "$worktree_dest"
                and set resolved true
                or begin
                    cd -
                    return 1
                end
            else
                cd -
                return 1
            end
        end

        if test "$resolved" = false
            echo "$err" >&2
            cd -
            return 1
        end
    end
    cd -

    # Process .worktree-setup if it exists in the main repo
    set -l worktree_path "$current_workspace/$repo_name"
    if test -f "$repo_path/.worktree-setup"
        while read -l line
            set -l parts (string split " " $line)
            if test "$parts[1]" = "symlink"; and test -n "$parts[2]"
                set -l src "$repo_path/$parts[2]"
                set -l dst "$worktree_path/$parts[2]"
                if test -e "$src"; and not test -e "$dst"
                    ln -s "$src" "$dst"
                    echo "Symlinked $parts[2] from main repo"
                end
            end
        end < "$repo_path/.worktree-setup"
    end
end
