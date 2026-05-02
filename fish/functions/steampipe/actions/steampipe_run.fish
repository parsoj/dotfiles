function steampipe_run
    steampipe service stop
    steampipe service start --database-password pwd
end
