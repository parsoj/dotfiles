function launcher_macos_app_list --description "list macOS apps as launcher items"
    for dir in /Applications /System/Applications
        test -d "$dir"; or continue

        command find "$dir" -maxdepth 1 -name "*.app" | while read -l app
            set -l name (basename "$app" .app)
            printf 'APP\t%s\t%s\n' "$app" "$name"
        end
    end
end
