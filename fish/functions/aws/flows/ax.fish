function ax --description "pick an aws profile and export it as AWS_PROFILE"
    set -l profile (aws_profile_list | fzf --prompt="aws profile> ")
    test -n "$profile"; and aws_profile_set $profile
end
