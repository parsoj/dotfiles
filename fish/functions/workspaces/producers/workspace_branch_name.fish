function workspace_branch_name --argument-names name --description "sanitize a workspace name into a git branch name"
    string replace -ra '[^A-Za-z0-9._-]' '-' -- "$name" | string trim -c '-.'
end
