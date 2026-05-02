function local_port_list
    lsof -i -P -n | grep LISTEN
end
