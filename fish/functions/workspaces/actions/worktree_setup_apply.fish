# @inputs repo_path:string, worktree_path:string
function worktree_setup_apply --argument-names repo_path worktree_path --description "apply .worktree-setup directives from the main repo to a worktree"
    test -f "$repo_path/.worktree-setup"; or return 0

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
