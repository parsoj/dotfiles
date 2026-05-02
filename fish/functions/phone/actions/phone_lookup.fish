function phone_lookup --description "Look up CNAM data for a phone number"
    if test (count $argv) -eq 0
        echo "Usage: phone_lookup <phone_number>"
        echo "Example: phone_lookup 2125551234"
        return 1
    end

    set -l phone $argv[1]
    curl -s "https://freecnam.org/dip?q=$phone"
    echo
end
