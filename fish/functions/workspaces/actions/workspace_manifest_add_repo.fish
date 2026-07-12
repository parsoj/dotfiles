# @inputs workspace_path:string, repo_name:string, branch:string
function workspace_manifest_add_repo --argument-names ws rname rbranch --description "record a repo in the workspace manifest and commit it on the workspace branch"
    test -n "$ws" -a -n "$rname" -a -n "$rbranch"; or return 1

    set -l manifest "$ws/.workspace.json"
    set -l tmp (mktemp)

    if test -s "$manifest"
        jq --arg n "$rname" --arg b "$rbranch" \
            '(.repos //= []) | if (.repos | any(.name == $n)) then . else .repos += [{name: $n, branch: $b}] end' \
            "$manifest" > "$tmp"
        or begin
            rm -f "$tmp"
            echo "workspace_manifest_add_repo: manifest is not valid JSON: $manifest" >&2
            return 1
        end
    else
        jq -n --arg n "$rname" --arg b "$rbranch" '{repos: [{name: $n, branch: $b}]}' > "$tmp"
    end

    mv "$tmp" "$manifest"

    # Commit on the workspace branch so worktrees created from this branch
    # inherit the manifest (what makes bare `git worktree add` + the
    # post-checkout sync hook yield a fully populated workspace).
    if test -f "$ws/.git"
        git -C "$ws" add .workspace.json
        git -C "$ws" commit -q -m "workspace: add repo $rname" 2>/dev/null
    end
end
