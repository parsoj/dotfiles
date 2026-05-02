# @inputs profile:string
function aws_set_profile --argument-names profile --description "set AWS_PROFILE for this shell"
    test -n "$profile"; or return 1
    set -gx AWS_PROFILE $profile
end
