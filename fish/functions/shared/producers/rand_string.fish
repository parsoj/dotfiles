function rand_string
    set length $argv[1]
    head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c $length ; echo ''
end

