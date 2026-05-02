function gms
    gm $argv
    or return 1
    gt submit --stack --draft --ai 2>/dev/null
    or echo "Graphite submit skipped (not a graphite repo)"
end
