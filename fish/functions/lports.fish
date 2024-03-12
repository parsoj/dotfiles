function lports
    lsof -i -P -n | grep LISTEN
end
