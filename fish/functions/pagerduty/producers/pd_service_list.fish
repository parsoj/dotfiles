function pd_service_list --description "list PagerDuty services as 'id\\tname' lines"
    pd service list --json 2>/dev/null \
        | jq -r '.[] | "\(.id)\t\(.name)"'
end
